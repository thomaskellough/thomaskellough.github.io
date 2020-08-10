---
date: 2020-07-29 22:12
description: Part two of adding biometric authentication to your app. This part focuses on handling success and failure for authentication.
tags: FaceID, TouchID, Extensions, Alerts, Autolayout
featuredDescription: Add Face ID and Touch ID with just four lines of code!
---
# Use Face ID and Touch ID to lock your app from prying eyes - Part 2

<div class="post-tags" markdown="1">
        <a class="post-category post-category-faceid" href="/tags/faceid">FaceID</a>
        <a class="post-category post-category-touchid" href="/tags/touchid">TouchID</a>
        <a class="post-category post-category-extensions" href="/tags/extensions">Extensions</a>
        <a class="post-category post-category-alerts" href="/tags/alerts">Alerts</a>
        <a class="post-category post-category-autolayout" href="/tags/autolayout">Autolayout</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/02-biometrics-uikit-part-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/02-biometrics-uikit-part-03" style="text-decoration: none">Adding a login button &rarr;</a></th>
    </tr>
</table>

### Handling Failure

Now at this point and time we can ask for identification, but nothing actually happens yet no matter if the user passes or fails their test. Let's fix that now. Let's start by handling the failure. We need to create two error messages, one for handling the case if there is no biometry available to users and the other for if they fail their biometry test. Now if you tried to add an alert right now you wouldn't be able to since it is a subclass of UIViewController. So you need to add an import statement for UIKit while also making our Biometrics class a subclass of UIViewController. Are there other ways around this? Absolutely, but remember, I'm trying to show you how to create something that is easily reusable. You can adjust it as needed in your own project. Add your import statement and edit your class like below.

```
...
import UIKit

// MARK: Class initialization
class Biometrics: UIViewController {
...
```

Now back to it. Since we are going to have more than one message, let's go ahead and create a basic alert function as well as two functions that call our basic alert function with specific parameters. You can add this inside your Biometrics class or create an extension below it. I will do the latter here. 

```
// MARK: Biometric UIAlerts
extension Biometrics {
    
    func showAlertForBiometryUnavailable() {
        let title = "Biometry unavailable"
        let message = "Your device is not configure for biometric authentication"
        showAlert(title: title, message: message)
        
    }
    
    func showAlertForFailedVerification() {
        let title = "Authentication failed"
        let message = "Verification failed. Please try again"
        showAlert(title: title, message: message)
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
}
```

Then we need to call our functions inside authenticateUser(). Note that we need to call `self?` for showAlertForFailedVerification because we are using `[weak self]` inside of our closure. Edit authenticateUser() to look like this

```
func authenticateUser() {
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
        
        let reason = "Please login using TouchID in order to have access to this app"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            [weak self] success, error in
            
            DispatchQueue.main.async {
                if success {
                    // User passed
                } else {
                    self?.showAlertForFailedVerification()
                }
            }
        }
    } else {
        showAlertForBiometryUnavailable()
    }
}
```

Now go ahead and run your code and fail the biometry portion! You'll notice that you don't actually get the error message. What gives? 

I admit, this part is a bit annoying, but it also teaches you a way to handle this. The UIAlert wants to be displayed from the top level view controller, however, we are currently looking at our main view controller and calling a function from our biometrics (now view controller). What we can do is create an extension that finds the top view controller for us and then displays the alert over it. That means we also need to edit the line that actually presents our view controller for us. Add this extension below, and edit `present(ac, animated: true)` as well.

```
// MARK: UIApplication Extensions
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
```

```
func showAlert(title: String, message: String) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    UIApplication.topViewController()?.present(ac, animated: true, completion: nil)
}
```
Now you should be able to run your app, fail authentication, and see your error pop up!

### Handling Success
Now it's time to actually make this app need a reason to use biometrics. Remember how we edited our main view controller to have one color then our launch screen to have a different color along with a logo? Did you notice that when you launch your app you show your launch screen for a short amount of time and then it still changes to the next view controller? What I want to do is show you how to hide your main view controller until the user passses authentication. Now we can't actually extend the length of time that the launch screen shows, but we can create an initial screen to look exactly like our launch screen. That was the reason I had you use those specific constraints when creating it in the first place.

The first step is creating a function that makes a new view that looks exactly like our launch screen in code. You can always create the same screen in storyboard, but doing it this way allows you to reuse this code easily in other apps. Here are the steps.

1) Create an optional UIView property so we can show it and dismiss it as we please

2) Create the function with parameters for background color, an image, width, and fourth parameter of a uiview that we will pass in from our main view controller

3) Inside the function created in step 2 we will initialize the lockscreen, create an image view, add constraints, and display it on our main screen behind our biometric authentication

Add this property now inside your Biometrics class

```
var lockScreenView: UIView?
```

Then create the following function for steps 2 and 3

```
// MARK: Configure Lockscreen
extension Biometrics {
    
    func showLockedScreen(backgroundColor: UIColor, logo: UIImage?, width: CGFloat, toView view: UIView) {
        lockScreenView = UIView()
        assert(lockScreenView != nil, "There was a problem creating the lock screen view")
        lockScreenView!.translatesAutoresizingMaskIntoConstraints = false
        lockScreenView!.backgroundColor = backgroundColor
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        assert(logo != nil, "Could not find image!")
        imageView.image = logo!
        imageView.contentMode = .scaleAspectFit
        
        lockScreenView!.addSubview(imageView)
        imageView.widthAnchor.constraint(equalTo: lockScreenView!.widthAnchor, multiplier: width).isActive = true
        imageView.centerXAnchor.constraint(equalTo: lockScreenView!.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: lockScreenView!.centerYAnchor).isActive = true
        
        view.addSubview(lockScreenView!)
        lockScreenView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lockScreenView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lockScreenView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lockScreenView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
```

There's a bit going on here so I want to explain what is happening. The `assert()` function is optional. It just causes your app to fail if there is no logo found. This ensures you type it in correctly.
The `lockScreenView!.translatesAutoresizingMaskIntoConstraints = false` allows us to edit our constraints by code.  Then we create a new image using code and attach our logo as its image that will be passed in as a parameter when we call the function. We then add the lockscreen view to our subview and *then* we set the contsraints. The order here matters. Note that we also pass in a width parameter. Remember in the beginning when we set the width of our logo to 70% of its parent view? When we call showLockedScreen() we can add in 0.7 to set our second logo to the same size so it doesn't look like the screen changes from the launch screen to our locked screen. This isn't perfect, but it's decent enough for now. You may want to adjust this part yourself for your own project. Then, we add our lockScreenView to another view, which will also be passed in as a parameter when calling the function. We will pass in the view of mainViewController since that is the intial view controller shown after the launch screen. Finally, we need to call this function. Let's go ahead and add our fourth line of code to `ViewController.swift`, by calling the function and passing the correct parameters.

```
class ViewController: UIViewController {
    
    var biometrics: Biometrics?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        biometrics = Biometrics()
        biometrics?.showLockedScreen(backgroundColor: .systemYellow, logo: UIImage(named: "logo"), width: 0.7, toView: self.view)
        biometrics?.authenticateUser()
    }
    
}
```
Finally, we need to dismiss our lockScreenView if our authentication passes. We will do this by removing the lock screen from it's superview. Edit your code to look like this

```
...
DispatchQueue.main.async {
    if success {
        self?.lockScreenView?.removeFromSuperview()
    } else {
        self?.showAlertForFailedVerification()
    }
}
...
```

Run your code and you should be able to pass authentication and see your view controller!

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/02-biometrics-uikit-part-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/02-biometrics-uikit-part-03" style="text-decoration: none">Adding a login button &rarr;</a></th>
    </tr>
</table>
