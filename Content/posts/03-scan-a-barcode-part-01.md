---
date: 2020-08-01 22:12
description: Phones have come a long way from just making calls and text messaging. You're now able to use your phone to scan barcodes, such as a drivers license, that collects data and displays in just seconds.
tags: AVFoundation, Navigation, UIKit
---
# Use AVFoundation to create a scanner to scan your drivers license - Part 1

<div class="post-tags" markdown="1">
        <a class="post-category post-category-avfoundation" href="/tags/avfoundation">AVFoundation</a>
        <a class="post-category post-category-navigation" href="/tags/navigation">Navigation</a>
        <a class="post-category post-category-uikit" href="/tags/uikit">UIKit</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-single-right"><a href="/posts/03-scan-a-barcode-part-02" style="text-decoration: none">Capturing data &rarr;</a></th>
    </tr>
</table>

### Introduction
If you're making an app you may need to use the phones camera to scan some sort of barcode. This tutorial will show you how to set up a project to scan your driver's license and display the information on a screen. Let's start by creating a new Xcode project and choosing a Single View App template,  Swift for your langauge, and Storyboard for your user interface. The first thing you should do is go into your project settings and lock your orientation to "Portrait" and uncheck "Upside Down", "Landscape Left", and "Landscape Right". Go ahead and also check "Requires full screen". Then head to storyboard and add a Text View to the view controller and set some constraints. You also want to give your Text View a background color so we can clearly see it. This is where all the information from your drivers license will go. Here's a screenshot of how I set mine up. 

<img class="post-image" src="/Images/Posts/03/03-01.png" alt="Storyboard initial setup" />

Let's create an outlet for this textview inside `ViewController.swift` so we can do something with it later. Using the assistant editor `ctrl + drag` from the Text View you created to the top of  your view controller class and name it `textLabel`. You can access the assistant editor by pressing `ctrl + option + cmd + enter`. After adding our outlet, click your view controller, go up into `Editor > Embed In > Navigation Controller`. When you are finished with that add a second view controller and give it a `Storyboard ID` of `scannerViewController`. We will need to come back in here in just a moment, but let's go ahead and jump into some code. Head over to `ViewController.swift` and let's add the following things. 

1) A bar button item to allow us to open the camera to start a scan

2) A function to update our label once we have a successful scan

3) A way to navigate to our new view controller when we press the button

For the first part add the following insde of `viewDidLoad()` of `ViewController.swift`

```
let scanBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(scanBarcode))
navigationItem.rightBarButtonItem = scanBarButtonItem
```

The second part is partially done by adding the below function, but we will fill it in later. I just want to leave a reminder to come back.

```
func updateLabel() {
    // this will be where we update our label
}
```

For the last part (and a way to remove the error we now have) add the following funciton. 

```
@objc func scanBarcode() {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "scannerViewController") as? ScannerViewController {
        navigationController?.pushViewController(vc, animated: true)
    }
}
```

However, this causes another error because we don't actually have a `ScannerViewController` yet. So create new swift file, make it a template of `Cocoa Touch Class` with a subclass of `UIViewController` and give it the name `ScannerViewController`. Then you can head back over to `main.storyboard` and set the custom class to the new `ScannerViewController` that you just created. When you're finished, your `ViewController.swift` should look like this.

```
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scanBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(scanBarcode))
        navigationItem.rightBarButtonItem = scanBarButtonItem
    }
    
    @objc func scanBarcode() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "scannerViewController") as? ScannerViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }


    func updateLabel() {
        // this will be where we update our label
    }
    
}
```

### Setting up an AVCaptureSession
Apple already has a great framework for us to use to achieve scanning using our phones. We are going to use `AVCaptureSession` to help us coordinate the flow of data from a visual input to some sort of output. Let's start by adding the following in our `ScannerViewController`

```
import AVFoundation
import UIKit

class ScannerViewController: UIViewController {

    var avCaptureSession: AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
```

Then let's create a function to set up our capture session. Add this function next.

```
func setUpScanner() {
    avCaptureSession = AVCaptureSession()
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
    
    do {
        let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        if avCaptureSession.canAddInput(videoInput) {
            avCaptureSession.addInput(videoInput)
        } else {
            // Add error message here
            return
        }
    } catch {
        // Add error message here
        return
    }
    
    avCaptureSession.startRunning()
}
```
Now what this does is create an `AVCaptureSession()` and a capture device. If for some reason there is no camera then the function will perform an early exit to prevent your code from crashing. Since it's possible there won't be any kind of video input we need to wrap this up in a `do catch` statement. If everything is successfull, we will add a video input and start running our session. Finally, call your function inside viewDidLoad by adding

```
setUpScanner()
```

However, if you run your app now you'll get this error. `This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.` Apple cares about privacy and does not want you accessing video or audio input from a user without their permission. To fix this navigate over to `info.plist` and add this key and string value.

```
Privacy - Camera Usage Description: We need access to your camera in order to scan barcodes.
```

We also want to stop our capture session when the view leaves. To do that, we will edit our `viewWillDisappear` function.

```
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if avCaptureSession?.isRunning == true {
        avCaptureSession.stopRunning()
    }
}
```

You should now be able to run your app and get the prompt asking for access to the camera. However, you won't see anything yet...

### Adding a preview layer
The reason you can't see anything is because we actually haven't created a layer to preview what the camera sees. This isn't complicated to do, but does require us to use another class called `AVCaptureVideoPreviewLayer`. 

At the top of your class add this variable

```
var avPreviewLayer: AVCaptureVideoPreviewLayer!
```

Then let's create a function to create an instance of our preview layer. We want to call our function at the bottom of `setupScanner()`.

```
func addPreviewLayer() {
    avPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
    avPreviewLayer.frame = view.layer.bounds
    avPreviewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(avPreviewLayer)
}
```

This creates a layer for our avCaptureSession, sets the frame to the entire size of our view it's in, gives it an aspect fill ratio so it looks nice, then finally adds this preview layer we just created to our main view. Now you can run your code and see through your camera!

<table class="posts-table">
    <tr>
        <th class="th-single-right"><a href="/posts/03-scan-a-barcode-part-02" style="text-decoration: none">Capturing data &rarr;</a></th>
    </tr>
</table>
