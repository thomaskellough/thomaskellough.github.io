---
date: 2021-04-17 12:05
description: Allow users to change their app icon for your app.
tags: SwiftUI, AppIcon
---
# Learn how to change your app icon dynamically

<div class="post-tags" markdown="1">
    <a class="post-category post-category-swiftui" href="/tags/swiftui">swiftui</a>
    <a class="post-category post-category-appicon" href="/tags/appicon">App Icon</a>
</div>

### Introduction
App Icons are the very first thing users will see before opening your app. Most apps do not allow you to edit your app icon, but it's such a simple feature that doesn't take much work at all to give your user an extra experience to help make your app more unique to them. This tutorial will show you how to let users change the app icon based on the images that you have provided.


### Getting Started
Go ahead and start a new SwiftUI project. This app will be very simple and the only thing we will be doing is adding some images, editing the plist, adding ONE function, then adding a Picker. You can reuse either all of this or parts of it for your own projects. If you just want to look at the full solution you can do so [here](https://github.com/thomaskellough/iOS-Tutorials-SwiftUI).

#### Adding Images
If you're used to adding your app icon inside the Assets.xcassets folder then forget it now. When dealing with multiple app icons you can't just simply add various ones and expect that to work. You'll need to add every icon you want inside the project navigator. I find it easier to create a new folder called `AppIcons` and drop all the images in there to keep it organized. You'll also want to add @2x and @3x version for each icon. The sizes for this project are 160x160 and 180x180 for @2x and @3x respectively. Feel free to snag my images I created from GitHub or find your own. My images were just some triangles smashed together in Figma with different colors, nothing fancy. 

#### Editing your plist file
Now that you've added the images to your project, it's time to edit your plist to read those images. You can do this using the default property list view, but we deal with some nested dictionaries that can get quite confusing. It may be easier if you right-click `Info.plist` and `Open as Source Code`. I'm going to break it down step-by-step to make it easier to understand, but you can also scroll down to see the final solution if you prefer.

When you first open your plist as source code you'll see something like this:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
    </dict>
    <key>UIApplicationSupportsIndirectInputEvents</key>
    <true/>
    <key>UILaunchScreen</key>
    <dict/>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
</dict>
</plist>
```

We will star by adding a new dictionary right below the array of UIInterfaceOrientation options. Every time  you add a new object you'll also need to give it a key since it's wrapped in a larger dictionary. This key will be named `CFBundleIcons`. Add the following code.

```
<key>CFBundleIcons</key>
<dict>
</dict>
```

Inside the dictionary you just created we are going to add our primary icon. Once again, it's a dictionary so we need a key/value. Our value for this will be *another* dictionary (see, it can get confusing).

```
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
    </dict>
</dict>
```

Inside of our innermost dictionary, we will add two more key/values. One will be a key/array, and the other will be a key/boolean.

```
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
        </array>
        <key>UIPrerenderedIcon</key>
        <false/>
    </dict>
</dict>
```

You'll notice the key/value for `UIPrerenderedIcon`. This is unfortunately a very old setting that has to do with a gloss effect that isn't used anymore, but we need to keep it here.

Inside our array that we created, we will add just ONE string. This string value needs to be the name of your image without the @2/3x.png extension. My images are named:

```
redBlack
yellowPink
multiColor
blackGreen
```

This will also be our default icon when the user first launches the app. In my example, I'll be using `redBlack` as the default. 

```
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>redBlack</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <false/>
    </dict>
</dict>
```

At this point, you should be able to run your app and have an app icon on your device. Next, we will add our alternate icons.

When we first started editing the plist we added a dictionary with a key of `CFbundleIcons`. Inside that, we added another dictionary with a key of `CFBundlePrimaryIcon`. We are going to add a second dictionary (outside of the `CFBundlePrimaryIcon` dictionary) with a key of `CFBundleAlternateIcons`.

```
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>redBlack</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <false/>
    </dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
    </dict>
</dict>
```

Inside our `CFBundleAlternateIcons` dictionary let's create another key/dictionary. However, this time the key can be whatever you want. I use a good name for what my icon is, but it does not have to be the exact name of your image. For example, my png for my red and black icon is `redBlack@3x.png`, but I'm going to use a key of `Red and Black`.

```
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>redBlack</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <false/>
    </dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
        <key>Red and Black</key>
        <dict>
        </dict>
    </dict>
</dict>
```

Inside our new dictionary, we are going to do the same thing we did with our `CFBundlePrimaryIcon` dictionary. Add a `CFBundleIconFiles` string array and `UIPrerenderedIcon` boolean. The `UIPrerenderedIcon` boolean will once again be false, and the and `CFBundleIconFiles` string array will contain one string with a value of your alternate icon.

```
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>redBlack</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <false/>
    </dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
        <key>Red and Black</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>redBlack</string>
            </array>
            <key>UIPrerenderedIcon</key>
            <false/>
        </dict>
    </dict>
</dict>
```

Now we can repeat our steps and add as many alternate app icons as we want. I'm going to add three more. Feel free to copy and paste what you did and edit the key value for the inner dictionary and the string value for each image name you are using.

```
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>redBlack</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <false/>
    </dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
        <key>Red and Black</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>redBlack</string>
            </array>
            <key>UIPrerenderedIcon</key>
            <false/>
        </dict>
        <key>Black and Green</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>blackGreen</string>
            </array>
            <key>UIPrerenderedIcon</key>
            <false/>
        </dict>
        <key>Multi-Color</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>multiColor</string>
            </array>
            <key>UIPrerenderedIcon</key>
            <false/>
        </dict>
        <key>Yellow And Pink</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>yellowPink</string>
            </array>
            <key>UIPrerenderedIcon</key>
            <false/>
        </dict>
    </dict>
</dict>
```
You'll notice that I added my primary icon twice, once as the `CFBundlePrimaryIcon` and once as a `CFBundleAlternateIcon`. I did this for a reason that you'll find out soon enough, but it's not necessary. I find it easier to search just for alternate icons during my function that gathers all available icons. Feel free to edit this piece of code as you see fit. 

As you can see, all the dictionaries can get messy so it's much easier to add each icon in source code instead of the property list. However, when you are finished your expanded property list should look something like this.

<img class="post-image" src="/Images/Posts/15/15-01.png" alt="Final property list with icons added" width="800"/>

Go ahead and run your code and make sure it compiles. You should see the default icon as your app icon currently.

#### Getting available icons
We aren't going to make a beautiful UI or anything here, just a simple picker that shows a list of icons that the user can choose from. Let's start by creating the following.

1) A string array that holds the name of our app icons. Default will be just our primary icon

2) A string variable that holds our selected icon. Default will be our primary icon.

3) A VStack that contains a Picker that shows us our string array and string variable of available/selected icon.

Edit your content view to look like this:

```
struct ContentView: View {
    @State private var appIcons = ["redBlack"]
    @State private var selectedIcon = "redBlack"
    
    var body: some View {
        VStack {
            Picker("Choose your app icon", selection: $selectedIcon) {
                ForEach(appIcons, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}
```

Now, this does nothing interesting yet because we haven't actually done anything to see our available icons. You can add your icons to the array above if you'd like, but then if you ever add/remove an icon from your plist you have to edit this array, too. When writing code you want to only ever have to edit things in one place. Let's create an extension on our bundle that returns an array of possible choices we can use. 

You can do this however you'd like with either a function or variable, but I'm going to go with the route of creating a static variable. It will never be null because I'll set an empty array to return and only append any app icons that we can find. Let's get started by adding the following code:

```
extension Bundle {
    static var appIcons: [String] {
        var availableIcons = [String]()
        
        return availableIcons
    }
}
```

Searching through a bunch of dictionaries can get complicated, but I've tried to make it as easy as possible. Some people may disagree with my methods because I don't always check that an image exists. But my thought is since it's bundled in your source code and identified from the property list, there is no way that can be bad once your app is shipped. If it is, you've messed up enough where it's probably not even a good idea to have your app available to download. Since they are static files you can create tests that prevent you from deploying if they fail. 

The first thing we will do is get a full dictionary of our info.plist. If we can't get that, throw an error because something is horribly wrong.

```
extension Bundle {
    static var appIcons: [String] {
        var availableIcons = [String]()
        
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Could not get dictionary!")
        }
        return availableIcons
    }
}
```

Then we will grab all of our icons from that dictionary. Remember, we wrapped them all in a dictionary of their own with a key of `CFBundleIcons`.

```
extension Bundle {
    static var appIcons: [String] {
        var availableIcons = [String]()
        
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Could not get dictionary!")
        }
        
        if let icons = dictionary["CFBundleIcons"] as? [String: Any] {
            
        }
        
        return availableIcons
    }
}
```

Here's what I do. Instead of trying to append the primary icon and also the alternate icons, I just look for the alternate icons and add all of those. This is the reason I add my primary icon as an alternate icon as well. 

```
extension Bundle {
    static var appIcons: [String] {
        var availableIcons = [String]()
        
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Could not get dictionary!")
        }
        
        if let icons = dictionary["CFBundleIcons"] as? [String: Any] {
            if let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {
                
            }
        }
        
        return availableIcons
    }
}
```

And here is the part that some people may not agree with it. If we get `alternateIcons` then I just go ahead and add the key to our `availableIcons` array. Yes, it's possible that our images are not in our list, but once again, these items should *never* change once the app is shipped. If you write excellent XCTests to cover each icon then you'll be safe once the app is on the app store. 

```
extension Bundle {
    static var appIcons: [String] {
        var availableIcons = [String]()
        
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Could not get dictionary!")
        }
        
        if let icons = dictionary["CFBundleIcons"] as? [String: Any] {
            if let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {
                for (key, _) in alternateIcons {
                    availableIcons.append(key)
                }
            }
        }
        
        return availableIcons
    }
}
```

Let's now head back up to our `ContentView` and add an `.onAppear()` method to our `VStack`. We will use our bundle extension to set our app icons from our plist as soon as the screen appears.

```
struct ContentView: View {
    @State private var appIcons = ["redBlack"]
    @State private var selectedIcon = "redBlack"
    
    var body: some View {
        VStack {
            Picker("Choose your app icon", selection: $selectedIcon) {
                ForEach(appIcons, id: \.self) {
                    Text($0)
                }
            }
        }.onAppear(perform: {
            appIcons = Bundle.appIcons
        })
    }
}
```

Go ahead and test your app, you should be able to add and remove icons from your plist without editing anything else in your code.

#### Changing your app icon on selection
We are nearly finished now. You can launch your app and see the list of available icons. Now we just need to do something when the user changes the picker value. This is as easy as adding an `.onReceive` method to the end of your picker. Our publisher will be our selected icon variable and our closure will attempt to set the app icon using `UIApplication.shared.setAlternateIconName()`. We will attempt to catch an error and react accordingly. Edit your `ContentView` to look like this:

```
struct ContentView: View {
    @State private var appIcons = ["redBlack"]
    @State private var selectedIcon = "redBlack"
    
    var body: some View {
        VStack {
            Picker("Choose your app icon", selection: $selectedIcon) {
                ForEach(appIcons, id: \.self) {
                    Text($0)
                }
            }.onReceive([self.selectedIcon].publisher.first()) { (value) in
                UIApplication.shared.setAlternateIconName(selectedIcon) { error in
                    if let error = error {
                        print("Error setting icon! \(error.localizedDescription)")
                    } else {
                        print("Successfully set icon")
                    }
                }
            }
        }.onAppear(perform: {
            appIcons = Bundle.appIcons
        })
    }
}
```

Go ahead and run your app! You should be able to scroll through the picker and see a message that you set your new icon.

<img class="post-image img-md" src="/Images/Posts/15/15-02.png" alt="New icon selected message" width="800"/>

### Conclusion
I hope I helped you learn something new today with Swift and iOS development. Giving the user ability to change your app icon may seem small, but many people LOVE being able to organize their home screen by colors. App icons are also a way to implement in-app purchases that may earn you a few extra bucks. 

There are many ways you can improve on this. One way is by adding tests to ensure your app icons are always available before you deploy your app. If you don't want to add tests, I suggest finding a place to look for your image and make sure it exists before trying to allow users to change the icon in your app. You can also display your options to the user differently. Right now, it's just a Picker view with some text. It may be better to show an HStack or VStack of images so the user can see them prior to selecting them. 

If you'd like to find the source code for this project you can do so [here](https://github.com/thomaskellough/iOS-Tutorials-SwiftUI).
