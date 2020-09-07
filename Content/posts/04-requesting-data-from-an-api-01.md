---
date: 2020-08-20 22:12
description: API requests are very common in iOS apps. Alamofire makes calling API's a breeze and this tutorial will show you exactly how to do it. 
tags: API, UIScrollView, UIStackView, Autolayout, UIKit
---
# Use Alamofire to make an API request for NASA's Astronomy Picture of the Day - Part 1

<div class="post-tags" markdown="1">
        <a class="post-category post-category-api" href="/tags/api">API</a>
        <a class="post-category post-category-uiscrollview" href="/tags/uiscrollview">UIScrollView</a>
        <a class="post-category post-category-uistackview" href="/tags/uistackview">UIStackView</a>
        <a class="post-category post-category-autolayout" href="/tags/autolayout">Autolayout</a>
        <a class="post-category post-category-uikit" href="/tags/uikit">UIKit</a>
</div>

<table class="posts-table">
    <tr>
    <th class="th-single-right"><a href="/posts/04-requesting-data-from-an-api-02" style="text-decoration: none">Making the request &rarr;</a></th>
    </tr>
</table>

### Introduction
If you plan to become an iOS developer then chances are you will need to learn networking at some point. If you think about it, how do the apps you use change their data without you having to re-download a new app? Every time you open up a weather app it's not like the data is stored on your personal device. Otherwise, you'd have to download the app daily just to see the weather for the day! Instead, we use APIs, or Application Programming Interfaces. This allows our app to communicate with another application and exchange data. There are many different types of *API calls* that we can perform, but this tutorial will go over the most basic, which is collecting data from another application without sending anything. 

Let's start by looking at the type of data we are going to collect. As an astronomy lover, I wanted to pick a NASA API because they are very easy to use, highly informational, and many of them are completely *free*! Head over to [NASA's Open APIs](https://api.nasa.gov) and take a look at all what they have to offer. We are going to look at **APOD** which allows us to get an image of the day as well as some information about that image. Note that depending on what time you do this you may not be able to obtain any information. I don't know the exact time that this happens, but it seems to be closer to the evening when they are refreshing the new information for the next day. For example, it is currently 20:06 CST on 08/20/2010 and I don't get any data back. Running the request looks like this ```{"code":404,"msg":"No data available for date: 2020-08-21","service_version":"v1"}```. Rest assured, if you just wait a while (or try in the morning) you should get information back!

That being said, go ahead and sign up (it's completely free and very quick!) and receive your API key. After signing up from the link above you should see something like this:

<img class="post-image" src="/Images/Posts/04/04-01.png" alt="NASA API Key" width="800"/>

You'll see a few things here. You'll notice a long string of characters called an API key. When you request data, who receives it wants to know who it's coming from and how to react. This allows that exchange to happen. Invalid key, no data. Correct key, something can happen and it's tracked. This is used to count the number of times you make API calls because most people charge for their APIs. 

Note: You do not want to share your API key with anyone. Keep it secret! I'm sharing mine here because I'm not actually using this. That's not even my real email! You're more than welcome to use mine during this tutorial if you want, but I make no promises it will be active when you try or that its limits will be reached, which as of this time is 1,000 requests per hour. You can also use NASA's DEMO_KEY which limits you to 50 requests per day and 30 requests per hour.

Below the key you'll see a unique url. In my example it's ```https://api.nasa.gov/planetary/apod?api_key=cau6to6cGexfArd5RfO4Hq1pceMgWpIOpwYs1Y8E```. Now I say unique, but that's only becase of the API key. Anyone who makes this same API call will use ```https://api.nasa.gov/planetary/apod?api_key=``` plus their specific API key. This is how NASA knows who is making the call. There are many ways to test API's before you even start writing your code. One my favorites it's using Postman, which is covered in another tutorial [here](/posts/05-testing-apis-with-postman). However, for this simple request we can actually just click the link and it will open a new window that looks like this: 

<img class="post-image" src="/Images/Posts/04/04-02.png" alt="APOD 08-19-2020" width="800"/>

Let's prettify this and take a look at the data

```
{
   "date":"2020-08-19",
   "explanation":"Does the Sun change as it rotates? Yes, and the changes can vary from subtle to dramatic. In the featured time-lapse sequences, our Sun -- as imaged by NASA's Solar Dynamics Observatory -- is shown rotating though an entire month in 2014.  In the large image on the left, the solar chromosphere is depicted in ultraviolet light, while the smaller and lighter image to its upper right simultaneously shows the more familiar solar photosphere in visible light. The rest of the inset six Sun images highlight X-ray emission by relatively rare iron atoms located at different heights of the corona, all false-colored to accentuate differences. The Sun takes just under a month to rotate completely -- rotating fastest at the equator. A large and active sunspot region rotates into view soon after the video starts.  Subtle effects include changes in surface texture and the shapes of active regions. Dramatic effects include numerous flashes in active regions, and fluttering and erupting prominences visible all around the Sun's edge.  Presently, our Sun is passing an unusually low  Solar minimum in activity of its 11-year magnetic cycle. As the video ends, the same large and active sunspot region previously mentioned rotates back into view, this time looking different.",
   "media_type":"video",
   "service_version":"v1",
   "title":"The Sun Rotating",
   "url":"https://www.youtube.com/embed/2WRgXvdasm0"
}
```
You can see that we get a date, an explanation, a media type, service version, title, and a url. This is what we will use later on in Swift to make our model. It's important to know what you are getting back as well as what type. This is a very basic GET request, which means we are just *getting* data back and not sending any in. There are 5-6 properties (an optional copyright if it exists) and they are each just a single string. Simple!


### Setting Up
We haven't started writing any code yet. In fact, we haven't even opened up Xcode. Let's go ahead and do that now and create a new project using the Single View App template and Swift as your programming language. Name your project APOD or something else that you desire. There is one more thing I need you to do before we dig into the code portion. Swift has something called [URLSession](https://developer.apple.com/documentation/foundation/urlsession) that allows us to make API calls, but I'm a fan of [Alamofire](https://github.com/Alamofire/Alamofire) that helps make this process much easier and cleaner. You can install this however you wish, but if you are using cocoapods you just need to add `pod 'Alamofire'` to your podfile. Now make sure you close out Xcode and open up the APOD.xcworkspace instead of the APOD.xcodeproj since we are using a Cocoapod. 

### Creating the UI
We want to create our UI so that we can view our image and most of the data that is returned. Sometimes this data can be long and depending on your device may not fully fit. So we are going to need to set up a UIScrollView in case the data extends below the bottom of your screen. Here are the steps we need to take, taking care to follow the constraints exactly so our scroll view works:

1) Add a UIImageView at the top of your main view

2) Add a UIScrollView below the image view

3) Add a UIStackView inside the UIScrollView

4) Add four labels inside the UIStackView

5) Add constraints on your UIImageView and your UIScrollView to keep it nicely on the screen

6) Add constraints on your UIStackView to *match* the constraints on your UIScrollView. This part is important!

7) Create outlets for each label in your main view controller as well as the imageview

Here is what your storyboard should look like when you are finished:

<img class="post-image" src="/Images/Posts/04/04-03.png" alt="Storyboard setup" width="800"/>

Then after adding the outlets your ViewController.swift should look like this:

```
import Alamofire
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
```

Great! We have our UI set up. Feel free to play with the colors as you see fit. The next thing we want to do is add our API key and API url above our class. Remember, you should have your own API key for this because mine may not work by the time you try it. Add these two properties now replacing my key with yours:

```
let APIKey = "cau6to6cGexfArd5RfO4Hq1pceMgWpIOpwYs1Y8E"
let apiURL = "https://api.nasa.gov/planetary/apod?api_key="
```

<table class="posts-table">
    <tr>
    <th class="th-single-right"><a href="/posts/04-requesting-data-from-an-api-02" style="text-decoration: none">Making the request &rarr;</a></th>
    </tr>
</table>
