---
date: 2020-08-08 22:12
description: The final part of how to scan a barcode. We add some extra features in this section such as a torch and scan bounds. 
tags: AVFoundation, Torch, BezierPath
featuredDescription: Learn to scan a barcode using the AVFoundation framework to collect data!
---
# Use AVFoundation to create a scanner to scan your drivers license - Part 3

<div class="post-tags" markdown="1">
        <a class="post-category post-category-avfoundation" href="/tags/avfoundation">AVFoundation</a>
        <a class="post-category post-category-torch" href="/tags/torch">Torch</a>
        <a class="post-category post-category-bezierpath" href="/tags/bezierpath">BezierPath</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-single-left"><a href="/posts/03-scan-a-barcode-part-02" style="text-decoration: none">&larr; Capturing data</a></th>
    </tr>
</table>

### Adding a torch
Sometimes scanning a license is difficult when there is no light. Well, your phone comes with a light! Apple actually has something called [torch mode](https://developer.apple.com/documentation/avfoundation/avcapturedevice/1386035-torchmode) that allows us to easily toggle our light on and off. Let's start by adding a bar button item that we can use to toggle the light. Add this in `viewDidLoad` of `ScannerViewController`.

```
let torchButton = UIBarButtonItem(title: "Torch", style: .plain, target: self, action: #selector(toggleTorch))
navigationItem.rightBarButtonItem = torchButton
```
Right now we will get an error, because we have no `toggleTorch` function. Let's go ahead and add that now. Remember, we need `@objc` because we are using a selector here. This function will do the following

1) Check if the device is capable of video, if not it will perform an early exit

2) Check if the device has a light, if not it will perform an early exit

3) Lock the device for configuration so no other apps can control the light while we are trying to use it here

4) If the light is on turn it off and if it's off turn it on

5) Print an error if something went wrong

```
@objc func toggleTorch() {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    guard device.hasTorch else { return }
    
    do {
        try device.lockForConfiguration()
        
        if device.torchMode == .on {
            device.torchMode = .off
        } else {
            device.torchMode = .on
        }
        
    } catch {
        print("There was an error trying to use the torch")
    }
}
```
You should be able to run your app now and see a "Torch" button that you can tap to turn your light on and off. Have fun scanning in the dark!

### Adding scan bounds
There's one more thing I want to show you. You'll notice that when you turn on the scanner you have no idea where to place your barcode. Honestly, if you get it close to the middle you shouldn't have an issue, but we can make it a bit more user friendly if we add some scan bounds to help the user guide the barcode. Let's create a new function to do that for us now. We will do this by using `UIBezierPath` to draw a rectangle, color it accordingly, and add it to our preview layer. Once again, don't forget to call your function in `setUpScanner`. 

```
func showScanBounds() {
    let rectangle = UIBezierPath(rect: CGRect(x: 8, y: (view.bounds.size.height / 2) + 30, width: view.bounds.size.width - 16, height: 60))
    let boundLayer = CAShapeLayer.init()
    boundLayer.path = rectangle.cgPath
    boundLayer.fillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.1).cgColor
    boundLayer.strokeColor = UIColor.green.cgColor
    avPreviewLayer.addSublayer(boundLayer)
}
```
Start up your scanner and you should see something like this!

<img class="post-image" src="/Images/Posts/03/03-02.png" alt="Scanner with bounds" />

I hope this tutorial helped and if you'd like you can see the full source code for this project [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift/tree/master/How-To-Scan-A-Barcode).

<table class="posts-table">
    <tr>
        <th class="th-single-left"><a href="/posts/03-scan-a-barcode-part-02" style="text-decoration: none">&larr; Capturing data</a></th>
    </tr>
</table>
