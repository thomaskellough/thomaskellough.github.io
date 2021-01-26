---
date: 2021-01-24 12:05
description: This section focuses on getting your app set up.
tags: Feature, Cocoapods, Tabbar, Structs
featuredDescription: Create a unique Valentine's Day app!
---
# Create a unique Valentine's Day app for your loved one - Part 1

<div class="post-tags" markdown="1">
    <a class="post-category post-category-cocoapods" href="/tags/cocoapods">Cocoapods</a>
    <a class="post-category post-category-tabbar" href="/tags/tabbar">Tabbar</a>
    <a class="post-category post-category-structs" href="/tags/structs">Structs</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-single-right"><a href="/posts/13-x-things-i-love-about-you-part-02" style="text-decoration: none">Displaying Data and User Interaction &rarr;</a></th>
    </tr>
</table>

### Prerequisites
Requirements:

- Swift 5.2 (or later)

- macOS Catalina 10.15 (or later)

- Some experience in Swift

- Experience with UIKIt. There are some sections that are glossed over rather quickly. You can download the example app [here](https://github.com/thomaskellough/X-Things-I-Love-About-You) if you need to see how I did something.

### Introduction
Valentine's Day is a very popular holiday where you can express your love for someone else. Although you should be doing this 365 days out of the year, the day is extra special to some people. If you want to give your loved one a unique gift this year why not make them an app? This guide will show you how to do just that and you'll learn a lot of great code and techniques along the way.

If you're in a rush and don't want to follow the entire tutorial, you can download the app directly from github [here](https://github.com/thomaskellough/X-Things-I-Love-About-You).

<div class="column">
        <img class="post-image img-sm" src="/Images/Posts/13/13-05.gif" width="800"/>
        <img class="post-image img-sm" src="/Images/Posts/13/13-06.gif" width="800"/>
</div>

### Getting Started
This app will focus on using Swift and UIKit. Go ahead and create a new iOS App project called X-Things-I-Love-About-You with Swift as the language and Storyboard as the interface.

<div class="optional-container">
Optional: If you want to use cocoapods to make the app look a bit nicer there are some good Tabbar examples that you can use. Feel free to skip this section if you do not like using dependencies and want to create your own tabbar.
</div>
### Adding a Custom Tabbar using Cocoapods
[iOS Eample](https://iosexample.com/) gives us a lot of great examples we can use in our project. It lists different packages to enhance our apps without doing too much work on our end. I'll be using [SO Tabbar](https://iosexample.com/light-way-to-add-fancy-bottom-bar/), but feel free to pick a different one or use the default tab bar in UIKit.

To install using Cocoapods close your app and open terminal. Navigate to your project directory and type in:
```
pod init
open podfile
```
Edit your podfile to:
```
# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'X-Things-I-Love-About-You' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for X-Things-I-Love-About-You
  pod 'SOTabBar'
end
```

Close our your podfile. Then inside terminal type in:
```
pod install
```

Now that you have a pod installed you must use the xcworkspace as opposed to the xcodeproj. You can open your app directly from terminal with: 
```
open X-Things-I-Love-About-You.xcworkspace
```

#### Creating your SO Tabs
We are going to have two tabs for this app so we will need to go into storyboard and add the respective views. The first view controller you will add will be the "Compliment View Controller". Drag a regular view controller out into storyboard and give it the Storyboard ID of `ComplimentViewController`. Right after that, drag a table view controller out and provide it with a Storyboard ID of `ComplimentTableViewController`.

Now we need to create some classes to attach these view controllers to. Inside your project navigator create two new swift files.

1)  ComplimentViewController.swift as a CocoaTouch Class inherited from UIViewController

2) ComplimentTableViewController.swift as a CocoaTouch Class inherited from UITableViewController

Then back inside your storyboard, make each view controller a custom class of the view controllers you created above. 

Now we can set up our tabs. You can read the settings for SO TabController if you want, or copy what I have here. Navigate to ViewController.swift. and edit your file to look like this:
```
import UIKit
import SOTabBar

class ViewController: SOTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComplimentViewController")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComplimentTableViewController")
        
        let firstTabImage = UIImage(systemName: "bolt.heart.fill")?.withTintColor(UIColor.App.Secondary, renderingMode: .alwaysOriginal)
        let firstTabImageSelected = UIImage(systemName: "bolt.heart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        firstVC.tabBarItem = UITabBarItem(
            title: "<3",
            image: firstTabImage,
            selectedImage: firstTabImageSelected
        )
        
        let secondTabImage = UIImage(systemName: "heart.text.square.fill")?.withTintColor(UIColor.App.Secondary, renderingMode: .alwaysOriginal)
        let secondTabImageSelected = UIImage(systemName: "heart.text.square.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        secondVC.tabBarItem = UITabBarItem(
            title: "<3<3<3",
            image: secondTabImage,
            selectedImage: secondTabImageSelected
        )
        
        viewControllers = [firstVC, secondVC]
    }
    
    
    override func loadView() {
        super.loadView()
        
        SOTabBarSetting.tabBarTintColor = UIColor.App.Secondary
        SOTabBarSetting.tabBarBackground = UIColor.App.Primary
        SOTabBarSetting.tabBarSizeImage = 40.0
        SOTabBarSetting.tabBarCircleSize = CGSize(width: 65, height: 65)
        SOTabBarSetting.tabBarHeight = 60
    }
}
```

Take a look through this code and edit it with what you see fit. You must be using iOS 13 or higher to take advantage of the system images so if you want to support older versions you'll need to find your own images. I used the heart with a lightning bolt because my wife is a nurse and I thought it was fitting when I made this app for her, but this is your app to do with as you please so play around with it! You'll probably also want to edit the titles since I just used some placeholder hearts for mine.

If you try to run your code right now it won't work. That's because of the handful of `UIColor.App.Primary` and `UIColor.App.Secondary` pieces of code we have layered in. This is something I like to do with all my apps and I think it's a great way to organize app-specific attributes. Let's make this code compile and explain what's going on.

Create a new swift file called `UIColor+Extension.swift`. Then edit the file to look like this:
```
import UIKit

extension UIColor {
    enum App {
        static var Primary: UIColor  {
            let color = UIColor(named: "Primary")
            if color != nil {
                return color!
            } else {
                return UIColor.black
            }
        }
        static var Secondary: UIColor {
            let color = UIColor(named: "Secondary")
            if color != nil {
                return color!
            } else {
                return UIColor.white
            }
        }
    }
}
```

<div class="optional-container">
Note: I'm not going to go into details of Unit Testing here since I cover that at https://theswiftprotocol.com/posts/10-how-to-set-up-unit-testing/, but this is a great opportunity to add test cases for these UIColor extensions you just created.
</div>

Regardless of if you added testing or not, you'll need to create some app colors unless you want a white and black app. Navigate to `Assets.xcassets` and add in two new Color sets. Feel free to pick your own color scheme, but for our example, I'll be using:

1) Primary - hex #5DD29E

2) Secondary - hex #513A55


It feels like we've done a lot already and we haven't even launched our app yet. The good news is, it's now ready for its first viewing. Go ahead and run your app now and you should see something like this:

<img class="post-image img-sm" src="/Images/Posts/13/13-01.png" width="800"/>

### Adding a model class
Now that you have an app up and running we need to add a model for our data. Our model consists of the following:

1) A title

2) A compliment

3) An image

So, create a new file called `Compliments.swift` and edit it to look like this:

```
import Foundation

struct Compliment {
    let title: String
    let dialogue: String
    let image: String
}
```

This is just the struct that will contain our information. Our app is going to consist of many compliments so we can cycle through them every day. Let's create a way to return a list of compliments so we can use them in our app. In the same file, create a new struct with the following code.

```
struct AllCompliments {
    var compliments: [Compliment] {
        getCompliments()
    }
    
    func getCompliments() -> [Compliment] {
        var compliments: [Compliment] = []
        
        let complimentOne = Compliment(title: "Smile", dialogue: "I love the way you smile", image: "smile")
        let complimentTwo = Compliment(title: "Funny", dialogue: "You're the funniest person I know", image: "funny")
        let complimentThree = Compliment(title: "Confidence", dialogue: "Your confidence is alluring", image: "confidence")
        
        compliments += [complimentOne, complimentTwo, complimentThree]
        
        return compliments
    }
}
```

I feel like I don't need to tell you this, but you probably want to create your own title, dialogue, and add your own images. I used images from [https://www.freeimages.com](https://www.freeimages.com). However, when I made my wife the app I focused on images of us and our pets. For the number of compliments, that's up to you. That's what the "X" is for in X-Things-I-Love-About-You. If you're doing this for a birthday maybe you could make the X their age!

<table class="posts-table">
    <tr>
        <th class="th-single-right"><a href="/posts/13-x-things-i-love-about-you-part-02" style="text-decoration: none">Displaying Data and User Interaction &rarr;</a></th>
    </tr>
</table>
