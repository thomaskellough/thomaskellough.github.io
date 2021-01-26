---
date: 2021-01-24 12:07
description: This section focuses on adding animations and limiting the number of compliments that can be viewed on any given day.
tags: Animations, Dates, UserDefaults
---
# Create a unique Valentine's Day app for your loved one - Part 3

<div class="post-tags" markdown="1">
  <a class="post-category post-category-animations" href="/tags/animations">Animations</a>
  <a class="post-category post-category-dates" href="/tags/dates">Dates</a>
  <a class="post-category post-category-userdefaults" href="/tags/userdefaults">UserDefaults</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/13-x-things-i-love-about-you-part-02" style="text-decoration: none">&larr; Displaying Data and User Interaction</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/13-x-things-i-love-about-you-part-04" style="text-decoration: none">Adding local notifications &rarr;</a></th>
    </tr>
</table>

### Adding animations
Many people would agree that animations make apps more appealing. Let's figure out how we can do that here. Let's start by creating a new animation factory class so it's reusable for your other apps. Create a new swift file called `AnimationFactory.swift`. Let's create a function to animate our alpha component. The function will take three parameters, one for the uiview to animate, the duration of the animation, and the delay. You can hardcode these values if you want, but as I said before, this helps you reuse this class in other projects. Change your `AnimationFactory.Swift` to this:
```
import UIKit

struct AnimationFactory {
    func animateAlphaComponent(_ label: UIView, duration: Double, delay: Double) {
        label.alpha = 0
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: {
                label.alpha = 1
            })
    }
}
```
To test it out add the following variable to your class variables in `ComplimentViewController.swift`:
```
var animationFactory: AnimationFactory?
```

Then in `viewDidLoad` before you call `configureView()` add:
```
animationFactory = AnimationFactory()
```

Finally, at the end of  `configureLabel()` add the following line:
```
animationFactory?.animateAlphaComponent(label, duration: 1, delay: 0)
```

Awesome! You have a cool animation! By why stop there....

Let's add an animation for our image view. Back in animation factory add the folowing code:
```
func animateViewSmallToBig(_ view: UIView, duration: Double, delay: Double) {
    view.transform = CGAffineTransform(scaleX: 0/01, y: 0.01)
    
    UIView.animate(
        withDuration: duration,
        delay: delay,
        options: .curveEaseInOut,
        animations: {
            view.transform = .identity
        })
}
```

Then, at the end of `configureImageView` add the following line:
```
animationFactory?.animateViewSmallToBig(imageView, duration: 1, delay: 0)
```

Now, this is cool and all, but it can be difficult to choose which animation you want to use. I have a solution for that. Why don't we create a way to randomize which animation you want to use! Create the following function in `AnimationFactory.swift`:
```
func randomAnimation(_ view: UIView, duration: Double, delay: Double) {
    let random = Int.random(in: 0...1)
    
    switch random {
    case 0:
        animateAlphaComponent(view, duration: duration, delay: delay)
    case 1:
        animateViewSmallToBig(view, duration: duration, delay: delay)
    default:
        animateAlphaComponent(view, duration: duration, delay: delay)
    }
}
```

Then instead of calling each animation specifically, we can use 
```
animationFactory?.randomAnimation(label, duration: 1, delay: 0)
```

Now when we cycle through and the animation is different every time.  You can add as many animations as you'd like this way!

### Only showing a certain number of compliments
I admit, when I originally made this app it was for my wife. Every year on her birthday she always tell me "Okay, now tell me X number of things you love about me" with X being her age. Of course, that means it's never more than 25....

I figured an app would be a great way to tell her, but my first thought was what would happen after she cycled through all the pictures right after she opened it? Most likely she would stop using it right away. Maybe she'd look at it from time to time, but how could I get her to look at it 25 separate days. 

Luckily, Apple has a solution for us. Using local notifications. Now using the notifications isn't enough, because she could easily just swipe up and ignore it since she knows what it is. But what if we limited the number of compliments she could see and only increased them each day? Once again, Apple has a solution for us. Since this is such a small app we can easily get away with using UserDefaults for our persistence. Let's start by configuring our app to only show the first compliment, then the next day show the first two, then the next day the first three, and so on.

Remember how we named our variable that held the index of which compliment to show in our array of compliments `currentDay`? This is the reason for that name. That index will be the current day that the user has opened and looked at the app. It will only increment up to the maximum number of days that the app has been opened. Let's start by setting our `currentDay` variable to a UserDefault value with a specific key. 

<div class="optional-container">
Tip: when you try to extract an integer from UserDefault and it does not exist, it returns 0. This is important to know because instead of your app crashing you could get unwanted results. However, this is useful for us in this scenario because we want our default value to be 0 then we can increment it every day.
</div>

Inside `viewDidLoad` of `ComplimentViewController` add the following line prior to `configureView()`:
```
currentDay = UserDefaults.standard.integer(forKey: currentDayKey)
```

Then as a class constant add:
```
let currentDayKey = "currentDayKey"
```

However, we will also need to store the date that the app was last opened, then compare it to the date the next time the app is open, determine if there is a difference of at least one day, then if so, increase our `currentDay` variable by 1. This will be handled in a series of steps.

1) Create a function to determine if the last saved date is the same as today. I'll write that below with a description of each step. We will also add a dateFormatter variable in the class variables section and a new last saved date key for UserDefaults: 

```
// Add this right under var currentDayKey = "currentDay"
var lastSavedDateKey = "lastSavedDate"
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd H:m:ss"
    formatter.timeZone = .current
    return formatter
}()

// Add this with all your other functions
func isSameDay() -> Bool {
    // Get today's date using the formatter so we are in the same timezone
    let todayPreFormat = Date()
    let todayString = dateFormatter.string(from: todayPreFormat)
    let today = dateFormatter.date(from: todayString) ?? Date()
    // Get the last saved date from user defaults, if it does not exist, get today's date
    let lastSavedDateString = UserDefaults.standard.string(forKey: lastSavedDateKey) ?? todayString
    // Using your date formatter from above, create a date from the last saved date string in user defaults
    let lastSavedDate = dateFormatter.date(from: lastSavedDateString) ?? today
    
    // Use the calendar function to determine if the dates are in the same day or not - then return the value
    return Calendar.current.isDate(today, inSameDayAs: lastSavedDate)
}
```

2)  In `viewDidLoad` compare the date our app is launched to the last saved date. If we are in the same day, continue like normal. However, if not we need to increment our current day only if it won't extend past the total number of compliments we have:

```
// Check if we are in the same day
if !isSameDay() {
    // We are not in the same day, so increment current day IF it will be less than the total number of compliments - 1. If we don't do this check, our app will continue to increment and eventually crash
    if currentDay < compliments.count - 1 {
        currentDay += 1
        // Set our new user default last saved date to today
        UserDefaults.standard.setValue(dateFormatter.string(from: Date()), forKey: lastSavedDateKey)
    }
}
```

3) We need to create two more UserDefault keys and set them. One for the current date in which we will set our `currentDay` variable based on that, as well as a max date key and value. Every time we load this app, currentDate and maxDay will be equal. However, `currentDay` will be able to change so the user can navigate back and forth, but `maxDate` will stay the same so they can't cycle through all compliments on the first day of opening the app. Create your key and set both values right under where we set `lastSavedDateKey` just above:

```
UserDefaults.standard.setValue(currentDay, forKey: currentDayKey)
UserDefaults.standard.setValue(currentDay, forKey: maxDaymaxDayKey)
```

4) Then, in the same place we hide our "next button", we need to also hide it if current day equals max day. This way each day we can see the next compliment and everything before it. Change `configureButtons()` to this:

```
func configureButtons() {
    let numberOfCompliments = compliments.count - 1
    let maxDay = UserDefaults.standard.integer(forKey: maxDayKey)
    nextButton.isHidden = currentDay == numberOfCompliments || currentDay ==  maxDay ? true : false
    previousButton.isHidden = currentDay == 0 ? true : false
}
```

5) We are almost done with this section. There is a problem here. If you run your app and change the date manually to the next day you'll see that we still can't move past that first screen. This is because of UserDefaults. Remember how when we don't have a value for integer we get back 0 which is a value? That's not the case with our `lastSavedDate` user default value. Since we don't have a good value to save, our nil coalescing in step 1 returns the string date of today. This means it `isSameDay` will always return true. This is an easy fix, however. We just need to check for a value when our app first launches, if it doesn't exist, set the value. Add this at the top of `viewDidLoad`:

```
// When app opens, set the last saved date to current date and time if needed - first run only
if UserDefaults.standard.value(forKey: lastSavedDateKey) == nil {
    UserDefaults.standard.setValue(dateFormatter.string(from: Date()), forKey: lastSavedDateKey)
}
```

You should now be able to launch the app the first time, only be able to view the first compliment, manually change the date on your phone, then you can view the next compliment, so on. So if you have 25 compliments, it will take 25 days before the user can see everything, unless of course they manually change the date.

That was a lot of code. Hopefully your app is working like it should. If not, please check your code with the following:
```
class ComplimentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let compliments = AllCompliments().compliments
    var currentDay = 0
    var selectedDay: Int?
    
    var animationFactory: AnimationFactory?
    
    var currentDayKey = "currentDay"
    var lastSavedDateKey = "lastSavedDate"
    var maxDayKey = "maxDay"
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd H:m:ss"
        formatter.timeZone = .current
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationFactory = AnimationFactory()
        
        // When app opens, set the last saved date to current date and time if needed - first run only
        if UserDefaults.standard.value(forKey: lastSavedDateKey) == nil {
            UserDefaults.standard.setValue(dateFormatter.string(from: Date()), forKey: lastSavedDateKey)
        }
        
        currentDay = UserDefaults.standard.integer(forKey: currentDayKey)
        // Check if we are in the same day
        if !isSameDay() {
            // We are not in the same day, so increment current day IF it will be less than the total number of compliments - 1. If we don't do this check, our app will continue to increment and eventually crash
            if currentDay < compliments.count - 1 {
                currentDay += 1
                // Set our new user default last saved date to today
                UserDefaults.standard.setValue(dateFormatter.string(from: Date()), forKey: lastSavedDateKey)
                UserDefaults.standard.setValue(currentDay, forKey: currentDayKey)
                UserDefaults.standard.setValue(currentDay, forKey: maxDayKey)
            }
        }
        
        configureView()
    }
    
    func configureView() {
        configureLabel()
        configureImageView()
        configureButtons()
    }
    
    func configureLabel() {
        currentDay = selectedDay != nil ? selectedDay! : currentDay
        selectedDay = nil
        
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.textColor = UIColor.App.Primary
        label.textAlignment = .center
        label.text = compliments[currentDay].dialogue
        
        animationFactory?.randomAnimation(label, duration: 1, delay: 0)
    }

    func configureImageView() {
        currentDay = selectedDay != nil ? selectedDay! : currentDay
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.App.Secondary.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5

        let image = UIImage(named: compliments[currentDay].image)
        imageView.image = image
        
        animationFactory?.randomAnimation(imageView, duration: 1, delay: 0)
    }
    
    func configureButtons() {
        let numberOfCompliments = compliments.count - 1
        let maxDay = UserDefaults.standard.integer(forKey: maxDayKey)
        nextButton.isHidden = currentDay == numberOfCompliments || currentDay ==  maxDay ? true : false
        previousButton.isHidden = currentDay == 0 ? true : false
    }
    func isSameDay() -> Bool {
        // Get today's date using the formatter so we are in the same timezone
        let todayPreFormat = Date()
        let todayString = dateFormatter.string(from: todayPreFormat)
        let today = dateFormatter.date(from: todayString) ?? Date()
        // Get the last saved date from user defaults, if it does not exist, get today's date
        let lastSavedDateString = UserDefaults.standard.string(forKey: lastSavedDateKey) ?? todayString
        // Using your date formatter from above, create a date from the last saved date string in user defaults
        let lastSavedDate = dateFormatter.date(from: lastSavedDateString) ?? today
        
        // Use the calendar function to determine if the dates are in the same day or not - then return the value
        return Calendar.current.isDate(today, inSameDayAs: lastSavedDate)
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        currentDay -= 1
        configureView()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        currentDay += 1
        configureView()
    }
    
}
```

### Fixing our tableview
Now that our main view shows only how many compliments we want, we need to make it so our tableview limits the number of compliments it shows. This isn't nearly as difficult as what we just did. We just need to edit our compliments array to return from index 0 to the max number of days. Find this line in `ComplimentsTableViewController.swift`:
```
let compliments = AllCompliments().compliments
```
And change it to this:
```
var compliments: [Compliment] {
    let days = UserDefaults.standard.integer(forKey: "maxDay")
    let compliments = AllCompliments().compliments
    
    return Array(compliments[0...days])
}
```
You'll note that we hardcoded the "maxDay" key here. This isn't best practice, but this is a small app that's not in production for thousands of users so I'm not too worried about it. Ideally, you could use a static variable for this key or even create a struct that contains all your user default keys (my preferred method). However, you can launch your app now and see that your tableview limits the number of compliments the user can navigate to. 

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/13-x-things-i-love-about-you-part-02" style="text-decoration: none">&larr; Displaying Data and User Interaction</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/13-x-things-i-love-about-you-part-04" style="text-decoration: none">Adding local notifications &rarr;</a></th>
    </tr>
</table>
