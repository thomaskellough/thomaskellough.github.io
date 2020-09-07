---
date: 2020-08-04 22:12
description: Part two of scanning a barcode. This section focuses on capturing the data and displaying it to the user.
tags: AVFoundation, Metadata, Delegates, UIKit
featuredDescription: Learn to scan a barcode using the AVFoundation framework to collect data!
---
# Use AVFoundation to create a scanner to scan your drivers license - Part 2

<div class="post-tags" markdown="1">
        <a class="post-category post-category-avfoundation" href="/tags/avfoundation">AVFoundation</a>
        <a class="post-category post-category-metadata" href="/tags/metadata">Metadata</a>
        <a class="post-category post-category-delegates" href="/tags/delegates">Delegates</a>
        <a class="post-category post-category-uikit" href="/tags/uikit">UIKit</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/03-scan-a-barcode-part-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/03-scan-a-barcode-part-03" style="text-decoration: none">Adding a torch and scan bounds &rarr;</a></th>
    </tr>
</table>

### Capturing Data
So far we have our camera up and running, but it doesn't actually do anything for us. We want to set it up to read a barcode and give us back that information. We will do this by using `AVCaptureMetaDataOutput`. We will break this up into two separate functions, one to read the data, and the other to return the data. Let's start by reading the data. We need to do the following

1) Create an instance of `AVCaptureMetadataOutput()`

2) If our capture session can add output, do so, otherwise present an error message

3) Provide the scan metadata object types 

Add the following function and call it at the bottom of `setupScanner()`

```
func addMetaData() {
    let metadataOutput = AVCaptureMetadataOutput()
    
    if avCaptureSession.canAddOutput(metadataOutput) {
        avCaptureSession.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.pdf417]
    } else {
        // Add error message here
        return
    }
}
```

You'll also need to have `ScannerViewController` conform to our metadataoutput by adding `AVCaptureMetadataOutputObjectsDelegate`. You'll notice that we passed in `.pdf417` as our object type because that's what many identification cards are. However, there are a ton more you can add here, including QR codes! I'll let you play with that on your own.

Reading the data is one thing, but we need to actually output the data so we can see it. This uses the `metadataOutput` function in AVFoundation, so you don't need to create it yourself. We will fill it in on our own, however. What this will do is collect our objects we see, take the first object and see if we can get a readable object out of it. If it can, we turn that into a string, play a vibration to notify us, then we will call one more function that we will create to update our label. Go ahead and add the following code, including the stub for the second function. 

```
func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    avCaptureSession.stopRunning()
    
    if let metadataObject = metadataObjects.first {
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
        guard let stringObject = readableObject.stringValue else { return }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        readMetaData(data: stringObject)
    }
    
    navigationController?.popViewController(animated: true)
}

func readMetaData(data: String) {

}
```

You should be able to scan your own drivers license now! Make sure you have good lighting and a decent barcode that isn't torn up or it may not work. 

### Adding the data to our label
Even though the code works, we don't actually see any results. We want to pass the data from one view controller to another so the method that we will be using here is delegates. We have two functions that we are going to link to each other. We need to set up a delegate first. So at the top of `ScannerViewController` add the following property

```
weak var delegate: ViewController!
```

This will give us a reference for our main view controller allowing us to use its functions. Then inside of `readMetaData()` we are going to call `updateLabel()` from `ViewController`. Edit `readMetaData()` to look like this.

```
func readMetaData(data: String) {
    delegate.updateLabel(text: data)
}
```

This also means we need to make a couple of updates in `ViewController`. We need to edit our `updateLabel()` function to accept a parameter and tell `ScannerViewController` who the delegate is during navigation. Match your functions to these below to achieve that.

```
@objc func scanBarcode() {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "scannerViewController") as? ScannerViewController {
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}


func updateLabel(text: String) {
    textLabel.text = text
}
```

Congratulations! Run your code, scan your license and look at all the data it returns! You will, however, notice that it's not very pretty. You can use some regex to parse that out, but we can cover that in another tutorial. 

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/03-scan-a-barcode-part-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/03-scan-a-barcode-part-03" style="text-decoration: none">Adding a torch and scan bounds &rarr;</a></th>
    </tr>
</table>
