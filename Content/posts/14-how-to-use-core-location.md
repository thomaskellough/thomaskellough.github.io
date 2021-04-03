---
date: 2021-04-02 12:05
description: Learn how to implement Core Location in your app
tags: Feature, SwiftUI, CoreLocation, Closures
featuredDescription: Add the Core Location framework to your app!
---
# Getting started with Core Location

<div class="post-tags" markdown="1">
    <a class="post-category post-category-swiftui" href="/tags/swiftui">swiftui</a>
    <a class="post-category post-category-corelocation" href="/tags/corelocation">Core Location</a>
    <a class="post-category post-category-closures" href="/tags/closures">Closures</a>
</div>

### Introduction
[Core Location](https://developer.apple.com/documentation/corelocation/) is a very useful framework that Apple provides for us that is fairly easy to use in your own apps. Core Location allows you to program the device to determine the user's location. As you can imagine, this can be a privacy issue and Apple takes privacy very seriously so you will need to let the user know why you are tracking their location and they must accept it. You need to be thinking about this when you write your code because you can't expect every single one of your users to allow themselves to be tracked. This means you need to write your code to handle what happens when a user declines. 


### Getting Started
We are going to write a very simple app using SwiftUI that tells us our location with a button tap. Start a new SwiftUI project now. We will create a few properties to get us started. One property will be a bool to determine if our location is successfully retrieved or not. The second property will be an empty string that will hold our coordinates.

```
@State private var locationRetrieved = false
@State private var coordinates: String = ""
```
Then we can create a button that allows the user to tap to determine their location as well as a Text() that will display location if it's been retrieved. Go ahead and wrap this in a VStack.
```
VStack(spacing: 10) {
    Button("Show location") {
        // get location
    }
    
    if locationRetrieved {
        Text("Your coordinates are: \(coordinates)")
    }
}
```
When you're finished  `ContentView` will look like this:
```
struct ContentView: View {
    @State private var locationRetrieved = false
    @State private var coordinates: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Button("Show location") {
                // get location
            }
            
            if locationRetrieved {
                Text("Your coordinates are: \(coordinates)")
            }
        }
    }
}
```
Right now you can run your app and tap the button, but nothing interesting happens yet. Create a new Swift file called `CoreLocationManager` that will handle everything involving Core Location for us.  To get started import the CoreLocation framework and make a `CoreLocationManager` class that inherits from `NSObject` and `CLLocationManagerDelegate`:
```
import CoreLocation

class CoreLocationManager: NSObject, CLLocationManagerDelegate {    

}
```
This class needs to hold a property of `CLLocationManager()` that will be used for nearly everything related to Core Location. Add the following as a class variable.
```
private var locationManager = CLLocationManager()
```
And now it's time for our first function. The first function we will write will set our `locationManager` delegate, set our desired accuracy, then allow the location manager to start determining the user's location. Add this function to your class.
```
func determineCurrentLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
    }
}
```

For reference, your `CoreLocationManager` should look like this:
```
import CoreLocation

class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}
```
Perfect! Now we can go back to our ContentView and allow the button to determine our location. First, add a reference to our new class.
```
private let coreLocationManager = CoreLocationManager()
```
Then, replace `// get location` with `coreLocationManager.determineCurrentLocation`. Go ahead and run your app and tap the button to determine your location.

Uh oh, it didn't work? Remember how I said that Apple takes privacy seriously? This is one of the ways this happens. You haven't yet told the user why you want to access their location. You can even see a warning in the console that looks like this:
```
2021-04-02 18:16:42.421676-0600 How-To-Use-Core-Location[4182:132602] This app has attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an “NSLocationWhenInUseUsageDescription” key with a string value explaining to the user how the app uses this data
```
This is easily handled in the `.plist` file of your project. Add the following key-value. 
```
Key: Privacy - Location When In Use Usage Description
Value: Please give us authorization to access your location so we can tell you your location
```
The value can say anything you want, but if it's not descriptive enough then Apple will reject your app from the app store.

Great, now you can run your app, tap the button, and see apple's built-in alert that will attempt to obtain confirmation from the user.

Next, you'll see that your `Text` isn't updated. The first reason is that we never toggled the boolean to allow it to show. The second reason is that we've only asked the app to update the location, but we never actually *get* that location. Let's head back over to `CoreLocationManager` and create a new function to return a coordinate. It's possible that we aren't able to get the user's location, so we need to make sure the return value is optional. Create the following function:
```
func getCurrentLocation() -> CLLocationCoordinate2D? {
    determineCurrentLocation()
    
    return locationManager.location?.coordinate
}
```

This will allow the device to use the previous function we created, then return the coordinate if it can be found. Head back over to `ContentView.swift` and edit what your button does to this:

```
determineLocation()
```

Now we need to create this function (still in `ContentView.swift`) which will do a few things. First, it will use our core location manager to get our current location. If we get a nil value, let's bail out and set our `locationRetrieved` variable to false. If we succeed let's break apart our longitude and latitude, update our coordinates text, then toggle our `locationRetrieved` variable to true.
```
func determineLocation() {
    guard let location = coreLocationManager.getCurrentLocation() else {
        locationRetrieved = false
        return
    }
    let latitude = location.latitude
    let longitude = location.longitude
    coordinates = "\(latitude), \(longitude)"
    locationRetrieved = true
}
```

Voila! You should now see your location appear in your app. Note that if you are using a simulator then you'll need to ensure there is a location enabled. This can be done by going to Features -> Location, and selecting one of the locations that is on the list. Simulators always default to none, so there's a high chance you'll need to do this. 

### Extending past coordinates
Core location is very powerful. It can do more than just determine your exact coordinates (which is a bit creepy), but it can even tell you the city, state, and address of where you. Let's create a new function inside `CoreLocationManager.swift`.

We are going to do the same thing as we did before by adding a bool, address string, new function to get address from `ContentView.swift` and a new function to get your address in `CoreLocationManager.swift`.  Edit your `ContentView` to this:

```
struct ContentView: View {
    @State private var locationRetrieved = false
    @State private var addressRetrieved = false
    @State private var coordinates: String = ""
    @State private var address: String = ""
    private let coreLocationManager = CoreLocationManager()
    
    var body: some View {
        VStack(spacing: 10) {
            Button("Show location") {
                determineLocation()
            }
            
            if locationRetrieved {
                Text("Your coordinates are: \(coordinates)")
            }
            
            Button("Show address") {
                showAddress()
            }
            
            if addressRetrieved {
                Text("Your address is: \(address)")
            }
        }
    }
    
    func determineLocation() {
        guard let location = coreLocationManager.getCurrentLocation() else {
            locationRetrieved = false
            return
        }
        let latitude = location.latitude
        let longitude = location.longitude
        coordinates = "\(latitude), \(longitude)"
        locationRetrieved = true
    }
    
    func showAddress() {
        coreLocationManager.getAddress { returnedAddress in
            guard let unwrappedAddress = returnedAddress else {
                addressRetrieved = false
                return
            }

            address = unwrappedAddress
            addressRetrieved = true
            
        }
        
    }
    
}
```

You'll notice something different with our `showAddress` function. When we use Core Location to get our address it will run in the background and return our information in a closure. So we need a completion handler to handle this for us. Not too difficult if you're familiar with closures, but it's a bit strange if you're not used to it. We also need to write our `coreLocationManager` function to return an escaping completion handler, because it may take a while to get the information back. When I say it may take a while, I mean in computer terms. It will be near-instantaneous from your perspective.

Let's write our `getAddress` function now in `CoreLocationManager.swift`. We need to first get our user's coordinates (which we already made a function for), then create a `CLLocation` object out of it. Then we need to create an instance of `CLGeocoder` and use reverse geocoding in order to get obtain something called *placemarks*. We can get an error here, so we first need to check if an error exists. If it does, just return your completion as nil. If not, check if placemarks exist (they should, but it's always good to be safe and prevent app crashes). If placemarks exist, we need to make sure we actually have some. It is possible to get more than one, but in this case, we just want to take the first one. I use a lot of `guard` statements, but feel free to unwrap however it makes you happy. Each placemark has different values that mean different things that may not make sense to you if you've never done this. The street address is called *name*, the city is called *locality*, and the state is called *administrative area*. Unwrap all of these, append it into one string, then return that string as your completion. 

```
func getAddress(completion: @escaping (String?) -> Void) {
    guard let coordinates = getCurrentLocation() else { return }
    let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        if error != nil {
            print("Error: \(error)")
            completion(nil)
        }
        
        if placemarks != nil {
            guard let first = placemarks?.first else {
                completion(nil)
                return
            }
            
            guard let street = first.name else { return }
            guard let city = first.locality else { return }
            guard let state = first.administrativeArea else { return }
            
            completion("\(street) \(city), \(state)")
        }
    }
}
```
Give your app a go! You'd be surprised at how accurate it is. 

I hope I helped you learn something new today with Swift and iOS development. It's great being able to implement something that is as powerful as Core Location. Try exploring other things that Core Location offers as we barely touched the surface. Or, use the basics and create your own weather app that can determine the weather near you. If you'd like to find the source code for this project you can do so [here](https://github.com/thomaskellough/iOS-Tutorials-SwiftUI/tree/main/How-To-Use-Core-Location).
