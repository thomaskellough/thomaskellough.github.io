---
date: 2021-01-24 12:06
description: This section focuses on displaying data and interacting with your app.
tags: UITableView, Optionals
---
# Create a unique Valentine's Day app for your loved one - Part 2

<div class="post-tags" markdown="1">
        <a class="post-category post-category-uitableview" href="/tags/uitableview">UITableView</a>
        <a class="post-category post-category-optionals" href="/tags/optionals">Optionals</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/13-x-things-i-love-about-you-part-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/13-x-things-i-love-about-you-part-03" style="text-decoration: none">Animations and UserDefaults &rarr;</a></th>
    </tr>
</table>

### Editing your main view
You can get creative with this, but for the purpose of this article, we will keep it simple. Inside Storyboard, add an image view, label, and two buttons on the screen. I gave the following constraints for each object:

1) UIImageView - top-to-safe-area 40, leading-to-safe-area-20, trailing-to-safe-area 20, height 330

2) Label - top-to-image-view 20, leading-to-safe-area-20, trailing-to-safe-area 20

3) Button 1 - leading-to-safe-area 20, bottom-to-safe-area-20

4) Button 2 - trailing-to-safe-area 20, bottom-to-safe-area-20

Delete both button titles and replace button 1 image with arrowshape.turn.up.left.fill and button 2 image with arrowshape.turn.up.right.fill. When you're finished you should have something that looks like this:

<img class="post-image img-lg" src="/Images/Posts/13/13-02.png" width="800"/>

Last, we will need to create some outlets for each object as well as an IBAction for each button. While you're here, create a constant and a variable for all of our compliments and the current day. When you're done your your `ComplimentViewController.swift` should look like this:
```
class ComplimentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let compliments = AllCompliments().compliments
    var currentDay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
    }
    
}
```

### Displaying Model Data
You've got your main view and you've got your model data. Let's begin showing it on the screen now. We want to also give our label and image view a bit of style, something else you can edit as your own. Add the following two functions:

```
func configureLabel() {
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.numberOfLines = 0
    label.textColor = UIColor.App.Primary
    label.textAlignment = .center
    label.text = compliments[currentDay].dialogue
}

func configureImageView() {
    imageView.layer.borderWidth = 8
    imageView.layer.borderColor = UIColor.App.Secondary.cgColor
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 5

    let image = UIImage(named: compliments[currentDay].image)
    imageView.image = image
}
```

Then to make the call easier for every edit add this function and call it in `viewDidLoad`

```
func configureView() {
    configureLabel()
    configureImageView()
}
```

Run your app now and you should see something like this:

<img class="post-image img-sm" src="/Images/Posts/13/13-03.png" width="800"/>

Awesome. Our app is finally starting to come together!

### Cycling through images
You'll notice that every time you run your app it shows the same image and same compliment. That's because we never change our `currentDay` variable. (If the variable name of currentDay sounds confusing right now, it will make sense later on!)

We need to edit both outlets to increase/decrease the current day and call the `configureView()` after each increment/decrement. This is as easy as changing both those stubs to this:
```
@IBAction func previousButtonTapped(_ sender: UIButton) {
    currentDay -= 1
    configureView()
}

@IBAction func nextButtonTapped(_ sender: UIButton) {
    currentDay += 1
    configureView()
}
```
<img class="post-image img-sm" src="/Images/Posts/13/13-04.gif" width="800"/>

Cycling through compliments is easy now, but you'll notice if you try to tap back from the first compliment or next at the last one your app will crash. You could put some try/catch blocks, or use if else's, or nil coalescing, or whatever your favorite way of error handling is, but I think it's better to just hide those buttons if they aren't useable. We will hide our `previous button` if the current day is equal to 0 and our `next button` if our current day is equal to the number of compliments minus 1. Then we will call this function in `configureView`. After adding the function for this your updated `ComplimentViewController.swift` should look like this.

```
class ComplimentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let compliments = AllCompliments().compliments
    var currentDay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        configureLabel()
        configureImageView()
        configureButtons()
    }
    
    func configureLabel() {
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.textColor = UIColor.App.Primary
        label.textAlignment = .center
        label.text = compliments[currentDay].dialogue
    }
    
    func configureImageView() {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.App.Secondary.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
    
        let image = UIImage(named: compliments[currentDay].image)
        imageView.image = image
    }
    
    func configureButtons() {
        let numberOfCompliments = compliments.count - 1
        nextButton.isHidden = currentDay == numberOfCompliments ? true : false
        previousButton.isHidden = currentDay == 0 ? true : false
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

### Editing your TableViewController
We have our main view working, but if end up having a ton of compliments (which you should....) then it may be easier to look through a tableview to find the one you want instead of hitting "next" over and over. Let's configure that now. If you haven't already, give your tableviewcell a reuse identifier of "cell" inside Storyboard. We need to do a few things...

1) Create a reference to our compliments

2) Return the number of rows as the number of compliments we have

3) Edit the row size to be a bit bigger so we can use our images inside the tableview cell

4) Configure each cell to show the picture and the title of your compliment

5) Configure the picture to be the same size in every row 

6) Navigate back to the view when tapping a cell

Creating a reference is as trivial as adding the following line as a property to our `ComplimentsViewController` class:
```
let compliments = AllCompliments().compliments
```

The next two things are easy enough:

```
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    compliments.count
}

override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    75
}
```

Configuring each cell to show the title and image is also fairly simple:
```
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    let compliment = compliments[indexPath.row]
    
    let image = UIImage(named: compliment.image)
    cell.imageView?.image = image
    cell.imageView?.contentMode = .scaleAspectFill
    
    cell.textLabel?.text = compliment.title
    
    return cell
}
```

But you'll notice that the images look a bit messed up. That's where step number five comes in. It's not a lot of code, but it isn't super intuitive either. I love UIKit, but there are many things that I think could make it better. We need to use an image context to draw the exact size that we want. With that being said, let's fix the pictures by adding the following code inside our `cellForRowAt` method right before we return the cell.
```
let itemSize = CGSize.init(width: 75, height: 75)
UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
cell.imageView?.image!.draw(in: imageRect)
cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
UIGraphicsEndImageContext();
```

Great, now our cells look good, but nothing happens when we tap them. For the final step, we need to break it down into a few small steps:

1) Embed our main view controller (the one with the tabs!) inside a navigation controller - which is done by going to Storyboard, selecting View Controller, the going to Editor > Embed In > Navigation Controller

2) Creating a *optional* variable called `selectedDay` inside `ComplimentViewController.swift'`  with *no* default value

3) Giving our `currentDay` variable in `ComplimentViewController.swift` the value of `selectedDay` if it exists

4) Giving that variable in the above step a value when we navigate to it from our `ComplimentsTableViewController.swift`


Step two is done with adding this line in `ComplimentViewController.swift` under your other class variables:
```
var selectedDay: Int?
```

The next step can be edited inside `configureLabel()` and `configureImageView()` by adding the following ternary operator at the top of each method:
```
currentDay = selectedDay != nil ? selectedDay! : currentDay
```

And step four is done by adding the following `didSelectRowAt` method in `ComplimentsTableViewController.swift`:
```
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "ComplimentViewController") as? ComplimentViewController {
        vc.selectedDay = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
```

You'll notice that you can now navigate from the tableview to the main view and it shows the correct picture, but your arrow buttons do not work correctly anymore. This is because `selectedDay` does not change and it's not nil anymore. There are many ways we can handle this, but we are just going to go the easy route here. Right after the line of code we added in step three, add the following:

```
selectedDay = nil
```
This means as soon as we navigate from the tableview and configure the view, we also set it back to nil so when we call `configureView` again the current day doesn't get set to `selectedDay`. Note that you only need to add this line in either `configureImageView` or `configureLabel` and not both places, however, it doesn't hurt if you do.

Just to recap what both files should look like take a look here:

```
class ComplimentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let compliments = AllCompliments().compliments
    var currentDay = 0
    var selectedDay: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    func configureImageView() {
        currentDay = selectedDay != nil ? selectedDay! : currentDay
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.App.Secondary.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
    
        let image = UIImage(named: compliments[currentDay].image)
        imageView.image = image
    }
    
    func configureButtons() {
        let numberOfCompliments = compliments.count - 1
        nextButton.isHidden = currentDay == numberOfCompliments ? true : false
        previousButton.isHidden = currentDay == 0 ? true : false
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

```
class ComplimentsTableViewController: UITableViewController {

    let compliments = AllCompliments().compliments
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        compliments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let compliment = compliments[indexPath.row]
        
        let image = UIImage(named: compliment.image)
        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFill
        
        cell.textLabel?.text = compliment.title
        
        let itemSize = CGSize.init(width: 75, height: 75)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ComplimentViewController") as? ComplimentViewController {
            vc.selectedDay = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
```

And honestly, if you want to stop here, write some compliments out for whoever you are making this app for, and give it to them, then by all means go for it! Buuuuut, if you stay a bit longer, we can spice it up a bit more. 

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/13-x-things-i-love-about-you-part-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/13-x-things-i-love-about-you-part-03" style="text-decoration: none">Animations and UserDefaults &rarr;</a></th>
    </tr>
</table>
