---
date: 2020-07-30 22:12
description: The final part of adding biometric authentication to your app. In this section you will learn to add a login button to call for authentication whenever you want.
tags: FaceID, TouchID, Obj-c, Closures, UIKit
featuredDescription: Add Face ID and Touch ID with just four lines of code!
---
# Use Face ID and Touch ID to lock your app from prying eyes - Part 3

<div class="post-tags" markdown="1">
        <a class="post-category post-category-faceid" href="/tags/faceid">FaceID</a>
        <a class="post-category post-category-touchid" href="/tags/touchid">TouchID</a>
        <a class="post-category post-category-obj-c" href="/tags/objc-c">Obj-c</a>
        <a class="post-category post-category-closures" href="/tags/closures">Closures</a>
        <a class="post-category post-category-uikit" href="/tags/uikit">UIKit</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-singl-left"><a href="/posts/02-biometrics-uikit-part-02" style="text-decoration: none">&larr; Handling Results</a></th>
    </tr>
</table>


### Adding a login button
At this point in time you have a fully working code that allows a user to either login successully or fail to login and receive an error message. However, after the error message shows there is no way to try authentication again without restarting the app. Let's go ahead and fix this by adding a button that only shows after a failed login attempt. Go ahead and add the the following line to your Biometrics class so we can declare a UIButton that may or may not exist at some point in time.

```
var loginButton: UIButton?
```

Once again, you can create this button however you want, even in Storyboard, but I want to do this all in code so it's easy to transport to other apps of yours. We will do the following things:

1) Create a UIButton from a variable above with a custom type

2) Make the button look a bit prettier by adding colors, borders, some edge insets, and a preferred font

3) Add our loginbutton to our lock screen view (this will be passed in as a parameter)

4) Create some constraints to keep the button towards the bottom of the screen fitting most of the width

5) Add a click function to the button that calls authenticateUser() so we can try authentication again

Feel free to edit this button as you see fit, but here's mine

```
// MARK: Configure loginbutton
extension Biometrics {
    
    func configureLoginButton(to view: UIView) {
        loginButton = UIButton(type: .custom)
        assert(loginButton != nil, "There was a problem creating the login button")
        
        loginButton?.backgroundColor = UIColor.systemGreen
        loginButton?.layer.cornerRadius = 8
        loginButton?.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        loginButton?.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        loginButton?.translatesAutoresizingMaskIntoConstraints = false
        loginButton?.setTitle("Login", for: .normal)
        loginButton?.setTitleColor(.white, for: .normal)
        
        view.addSubview(loginButton!)
        
        loginButton?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        loginButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        loginButton?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        loginButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginButton?.addTarget(self, action: #selector(authenticateUser), for: .touchUpInside)
    }
    
}
```

And then we need to call this function at the very bottom of `showLockedScreen()` like this

```
configureLoginButton(to: lockScreenView!)
```

Now that code will actually fail to compile right now with this error `Argument of '#selector' refers to instance method 'authenticateUser()' that is not exposed to Objective-C`. Anytime you add a selector in Swift (which here is using addTarget to the loginButton) we need to make sure we tell Swift that we are callling code from Objective-C. Fortunately, it's a very easy fix. Just add `@objc` before declaring the authenticateUser function so it looks like this

```
@objc func authenticateUser()
```

Now what I want to do is hide the button until it's needed. It's easy to show the button, but hiding it is a bit of a different story. To show the button, simply write this method at the very top of authenticateUser.

```
loginButton?.isHidden = true
```
Yes, we need to use the question mark because this button may or may not be nil at any point in our code. Now onto the more difficult part. We only want to hide the button if the user fails authentication which means we need to do something after clicking "OK" from that alert. This means we need to write a closure. If you don't know already, closures are self-contained blocks of functionality that can be used throughout your code and passed around as parameters if needed. Let's start with creating a parameter inside of `showAlert()` for an optional closure. We will make it optional because we have two different functions that call `showAlert()`, but we only want one to pass in a closure. The closure we write will take in a UIAlertAction as a parameter and return nothing. The syntax for that looks like `(UIAlertAction) -> Void)`. However, we do need to wrap it with another set of parentheses and a `?` since we are making it optional. Edit `showAlert` to look like this. Note that we added this parameter inside of `ac.addAction` but kept the completion nil in the third line of the function.

```
func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
    UIApplication.topViewController()?.present(ac, animated: true, completion: nil)
}
```
We now need to edit our two functions that call showAlert(). `showAlertForBiometryUnavailable()` can just pass in `nil` as it's completion. But we will use closure syntax for `showAlertForFailedVerification()` The closure looks like

```
{ action in
    self.loginButton?.isHidden = false
}
```
I know it's a bit strange, but it is very nice being able to do this in Swift. Wrapping these three functions up together should look like this when you are finished.

```
func showAlertForBiometryUnavailable() {
    let title = "Biometry unavailable"
    let message = "Your device is not configure for biometric authentication"
    showAlert(title: title, message: message, completion: nil)
    
}

func showAlertForFailedVerification() {
    let title = "Authentication failed"
    let message = "Verification failed. Please try again"
    showAlert(title: title, message: message, completion: { action in
        self.loginButton?.isHidden = false
    })
}

func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
    UIApplication.topViewController()?.present(ac, animated: true, completion: nil)
}
```
Go ahead and run your code now. Fail authentication enough times until you get the alert then watch the login button pop up. As soon as you tap the login button it disappears and prompts the biometric screening again!

I hope you enjoyed this tutorial and you're now able to easily implement biometrics inside your own apps. In case you were wondering, the four lines of code to make it all work are these

```
var biometrics: Biometrics?
biometrics = Biometrics()
biometrics?.showLockedScreen(backgroundColor: .systemYellow, logo: UIImage(named: "logo"), width: 0.7, toView: self.view)
biometrics?.authenticateUser()
```

Of course, you'll need to add the Biometrics class in, but that's as easy as dragging and dropping! You can see the full source code for this project [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift/tree/master/How-To-Setup-Biometrics/How-To-Setup-Biometrics)

<table class="posts-table">
    <tr>
        <th class="th-singl-left"><a href="/posts/02-biometrics-uikit-part-02" style="text-decoration: none">&larr; Handling Results</a></th>
    </tr>
</table>
