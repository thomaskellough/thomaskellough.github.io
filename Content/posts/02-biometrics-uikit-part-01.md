---
date: 2020-07-28 22:12
description: Privacy is one of the most important things when it comes to your personal device. Apple has created ways to allow developers to add privacy without much work on our end! You can add fully functioning Face ID or Touch ID inside your app with only four lines of code!
tags: Feature, FaceID, TouchID
featuredDescription: Add Face ID and Touch ID with just four lines of code!
---
# Use Face ID and Touch ID to lock your app from prying eyes - Part 1

<div class="post-tags" markdown="1">
        <a class="post-category post-category-feature" href="/tags/feature">Feature</a>
        <a class="post-category post-category-faceid" href="/tags/faceid">FaceID</a>
        <a class="post-category post-category-touchid" href="/tags/touchid">TouchID</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-single-right"><a href="/posts/02-biometrics-uikit-part-02" style="text-decoration: none">Handling Results &rarr;</a></th>
    </tr>
</table>

### Introduction
Okay, let's be clear here. When I say four lines of code, there is a caveat. You need to add the functionality first! But seriously, after this tutorial, you can reuse the code here and write four more lines of code for each app afterwards to add Face ID and Touch ID to all of your apps! If you are needing this in a rush, download the biometrics swift file [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift/blob/master/How-To-Setup-Biometrics/How-To-Setup-Biometrics/Biometrics.swift) and just drag and drop it in your app!

Let's start by creating a new Xcode project and choosing a Single View App template, Swift for your langauge, and Storyboard for your user interface. Head into Storyboard and give your view a background color. This is just so it's easier to see. If you forgot how to do that here is an image with some arrows of where you need to go. If you want, feel free to also add a text box that can hide a secret message. I think it makes it more fun. 

<img class="post-image" src="/Images/Posts/02/02-01.png" alt="Storyboard background color change"/>

After that I want us to add a launch screen. In your project navigator select `LaunchScreen.storyboard`. It looks very similar to `Main.storyboard`. I want you to add a background color here as well, but I want you to choose a different color for the launch screen and add a logo in the middle of it. In order to add a logo you'll need to drag an image view inside of your launch screen view and set some constraints. The constraints that I want you to set are

1) Image view to safe area - center x

2) Image view to safe area - center y

3) Image view to safe area - Equal widths, then go into the attributes inspector and set the multiplier by 0.7

4) Image view to itself - aspect ratio and set the ratio to 1:1 

5) Finally, add any kind of launch screen image you'd like. I'll be using a Swift logo.

Here are a few screenshots to help you out. To set the aspect ratio of the image view `ctrl + drag` from the image view to itself then select `Aspect Ratio`.

<img class="post-image" src="/Images/Posts/02/02-02.png" alt="Showing horizontal and vertical constraints"/>

<img class="post-image" src="/Images/Posts/02/02-03.png" alt="Setting width"/>

<img class="post-image" src="/Images/Posts/02/02-04.png" alt="Setting aspect ratio"/>


### Adding Biometrics class 
You should be able to run your app now and see your launch screen start up then quickly change to your main view controller. Let's go ahead and get started with the fun part. In order for us to use only four lines of code in the future, we need to create a custom class that contains nearly all of the requirements of adding biometric authentication. In all honestly, I'd probably separate the file into multiple parts in a real project, but for now this will do the trick. It also makes it easier to reuse in other projects this way.

Go ahead and create a new swift file called `Biometrics.swift` and add the following code

```
import Foundation
import LocalAuthentication

// MARK: Class initialization
class Biometrics {
    
}
```

This intial setup imports the LocalAuthentication module that allows us to access all of the biometric functions that Apple has created for us. I want to break down each piece so you understand what's actually happening. The first step is adding our function that we can call to authenticate our user and allow them access to our app. This function will do a few different things.

1) Create an LAContext() object which handles userinteraction and talks to the hardware element that manages the data collected from the biometrics of the device. LAContext() actually does all the heavy lifting for us by giving us a callback of an authentication check either passing or failing as well as an explanation of failing if there is one. 

2) Ask the LAContext() created in step one to check whether the phone has either FaceID or TouchID and also provide the user a reason for asking them to reveal themselves.

3) If the device is capable of either Face ID or Touch ID then proceed with the check.

4) Return either a success or failure that you can do with as you please.

Add this inside function your Biometrics class.

```
let context = LAContext()

func authenticateUser() {
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
        
        let reason = "Please login using Touch ID in order to have access to this app"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            [weak self] success, error in
            
            DispatchQueue.main.async {
                if success {
                    // User passed
                } else {
                    // User did not pass
                }
            }
        }
    } else {
        // Biometrics are unavailable
    }
}
```

Then inside `ViewController.swift` let's call this function to see it in action.

```
class ViewController: UIViewController {
    
    var biometrics: Biometrics?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        biometrics = Biometrics()
        biometrics?.authenticateUser()
    }
    
}
```
Now depending on what kind of device you run this on you may or may not get an error. If you run it on an iPhone that has Touch ID you won't have an issue, however, if you run it on an iPhone with Face ID you will get this error
`This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSFaceIDUsageDescription key with a string value explaining to the user how the app uses this data.` You'll notice that for the reason I wrote `let reason = "Please login using Touch ID in order to have access to this app"` and I didn't say anything about Face ID. As the error message says, we need to edit the `Info.plist` in the app to ask for permission to access this data, whereas, Touch ID is handled using code. Head over to `Info.plist` and add a new key called `Privacy - Face ID Usage Description` with a string value of `Please login using Face ID in order to have access to this app`. Note, you can edit this string value to whatever you want, just make sure it makes sense or Apple will reject it. 

<img class="post-image" src="/Images/Posts/02/02-05.png" alt="Editing info.plist"/>

You should now see both kinds of devices ask for authentication with Face ID or Touch ID. Wow, that was fast and easy!

<img class="post-image" src="/Images/Posts/02/02-06.png" alt="Editing info.plist"/>

<table class="posts-table">
    <tr>
        <th class="th-single-right"><a href="/posts/02-biometrics-uikit-part-02" style="text-decoration: none">Handling Results &rarr;</a></th>
    </tr>
</table>
