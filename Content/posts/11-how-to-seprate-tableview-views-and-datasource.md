---
date: 2020-11-27 14:48
description: How to separate your UITableViewController views and datasources 
tags: DesignPatterns, UIKit
---
# Separating your UITableViewController into multiple files

<div class="post-tags" markdown="1">
  <a class="post-category post-category-designpatterns" href="/tags/designpatterns">DesignPatterns</a>
  <a class="post-category post-category-uikit" href="/tags/uikit">UIKit</a>
</div>


### Introduction
This article is not to get into the notorious argument of MVC vs MVVM vs VIPER or any other design patterns that we Swift developers like to discuss amongst each other. There are more than ways to skin a cat (although, I'm not a fan of animal cruelty) and your preferred method may not be someone else's preferred method. However, after working on production code that had every view controller 500+ lines of code I was growing frustrated by seeing a lot of extra code that just made finding what I wanted more difficult. 

For example, if I have a Jira ticket that wants me to update what is showing in a tableview then I don't want to see all the methods that the view controller can perform. If I have another ticket that wants me to change how a tableview looks, I don't want to see filter through the code of what kind of data is shown. Some people may read this and think I'm lazy and it's not a big deal and perhaps you're right, but if you continue reading I'll show you how I like to separate my UITableViewControllers into three separate pieces that I think makes life easier.

### Creating a "regular" UITableViewController
Let's start by creating what most developers would recognize as a regular UITableViewController. This will be one Swift file that handles what the tableview shows, how the tableview and cells look, and the logic that ties everything together. 

Start by downloading the start project [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift) so you can follow along. This doesn't do anything exciting, just shows a handful of Game of Thrones characters that displays an alert when you tap their names.

The icons I used here can be found on https://icons8.com/icon/pack/cinema/officel in their Game of Thrones section and are free to use.

You'll notice that our Storyboard has one UITableViewController that is the class of `ViewController` which is currently our main Swift file. Our `ViewController` class looks like this:

```
import UIKit

class ViewController: UITableViewController {
    
    var characters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ned = Character(name: "Ned Stark", house: "Stark")
        let arya = Character(name: "Arya Stark", house: "Stark")
        let daenerys = Character(name: "Daenerys Targaryen", house: "Targaryen")
        let rhaegar = Character(name: "Rhaegar Targaryen", house: "Targaryen")
        let obern = Character(name: "Obern Martell", house: "Martell")
        let doran = Character(name: "Doran Martell", house: "Martell")
        let olenna = Character(name: "Olenna Tyrell", house: "Tyrell")
        let mace = Character(name: "Mace Tyrell", house: "Tyrell")
        
        characters = [ned, arya, daenerys, rhaegar, obern, doran, olenna, mace].sorted(by: { $0.name < $1.name })
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let character = characters[indexPath.row]
        
        cell.textLabel?.text = character.name
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        
        cell.detailTextLabel?.text = character.house
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        
        if let image = UIImage(named: character.house.lowercased()) {
            cell.imageView?.image = image
        }
        
        switch character.house.lowercased() {
        case "stark":
            cell.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        case "tyrell":
            cell.backgroundColor = UIColor(red: 144/255, green: 158/255, blue: 131/255, alpha: 1)
        case "targaryen":
            cell.backgroundColor = UIColor(red: 155/255, green: 44/255, blue: 41/255, alpha: 1)
        case "martell":
            cell.backgroundColor = UIColor(red: 227/255, green: 138/255, blue: 75/255, alpha: 1)
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        
        let ac = UIAlertController(title: character.name, message: character.house, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
}

```
We also have a very simple Character model class that looks like this 

```
struct Character {
    var name: String
    var house: String
}
```

Now I know what you're thinking, this view controller is only 76 lines long which isn't that much. That is absolutely true, but if you've ever worked on large iOS projects you'll know that a view controller that looks like this is rare. We have no logic inside of this view controller, no trailing swipe actions, no functions to call API data, and we lack many other pieces of code that you'll often see in the real world. Still, this can give us a good idea of how separation can help. I will warn you though, it's a bit more work and in the end, may even total more lines of code, but it's the separation that makes maintenance and reusability a lot easier. 

### Separate your data source
Tableviews do not manage data. It only represents the data that it is provided. In our example, this is all handled in the `ViewController.swift`. However, our view controller would be better off forgetting the data and just showing the data that we provide it. 

Create a new file called `CharacterDataSource.swift`. We want to move our data source methods out of our view controller here. Take a look at Apple's [UITableViewDataSource documentation](https://developer.apple.com/documentation/uikit/uitableviewdatasource) to see which methods these are. You'll see that only the following two methods are required:

```
// Return the number of rows for the table.     
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return 0
}

// Provide a cell object for each row.
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   // Fetch a cell of the appropriate type.
   let cell = tableView.dequeueReusableCell(withIdentifier: "cellTypeIdentifier", for: indexPath)
   
   // Configure the cell’s contents.
   cell.textLabel!.text = "Cell text"
       
   return cell
}
```

That means in our example we are looking at:

```
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    characters.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let character = characters[indexPath.row]
    
    cell.textLabel?.text = character.name
    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
    
    cell.detailTextLabel?.text = character.house
    cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    
    if let image = UIImage(named: character.house.lowercased()) {
        cell.imageView?.image = image
    }
    
    switch character.house.lowercased() {
    case "stark":
        cell.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
    case "tyrell":
        cell.backgroundColor = UIColor(red: 144/255, green: 158/255, blue: 131/255, alpha: 1)
    case "targaryen":
        cell.backgroundColor = UIColor(red: 155/255, green: 44/255, blue: 41/255, alpha: 1)
    case "martell":
        cell.backgroundColor = UIColor(red: 227/255, green: 138/255, blue: 75/255, alpha: 1)
    default:
        break
    }
    
    return cell
}
```
Note that there are other methods that belong to the data source, but in our example, we aren't using them.

Create an empty data source class as follows:

```
import UIKit

class CharacterDataSource: NSObject, UITableViewDataSource {
}
```

You'll notice that we need to inherit from `NSObject` and `UITableViewDataSource`. This is required.

When we add our two above functions we need to remove the `override` keyword because we aren't overriding the data source anymore since we are simply creating one. We will also need to provide a characters array that holds our data, which means removing our characters array from our `ViewController.swift`. 

When you are finished your `CharacterDataSource` class should look like this:

```
class CharacterDataSource: NSObject, UITableViewDataSource {
    
    var characters: [Character] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let character = characters[indexPath.row]
        
        cell.textLabel?.text = character.name
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        
        cell.detailTextLabel?.text = character.house
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        
        if let image = UIImage(named: character.house.lowercased()) {
            cell.imageView?.image = image
        }
        
        switch character.house.lowercased() {
        case "stark":
            cell.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        case "tyrell":
            cell.backgroundColor = UIColor(red: 144/255, green: 158/255, blue: 131/255, alpha: 1)
        case "targaryen":
            cell.backgroundColor = UIColor(red: 155/255, green: 44/255, blue: 41/255, alpha: 1)
        case "martell":
            cell.backgroundColor = UIColor(red: 227/255, green: 138/255, blue: 75/255, alpha: 1)
        default:
            break
        }
        
        return cell
    }
    
}
```

If you try to run this code it won't compile. That's because we removed our characters array from `ViewController.swift` and we haven't given it any new data. This is fixed by creating a datasource property and providing that property to our tableviews datasource. This also means everywhere we use `characters` inside `ViewController.swift` will have to be changed to `dataSource.characters`.

Edit `ViewController.swift` to look like this:

```
class ViewController: UITableViewController {
        
    let dataSource = CharacterDataSource() // we added a referece to our data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource // assign our tableview's datasource our datasource reference from above
        
        let ned = Character(name: "Ned Stark", house: "Stark")
        let arya = Character(name: "Arya Stark", house: "Stark")
        let daenerys = Character(name: "Daenerys Targaryen", house: "Targaryen")
        let rhaegar = Character(name: "Rhaegar Targaryen", house: "Targaryen")
        let obern = Character(name: "Obern Martell", house: "Martell")
        let doran = Character(name: "Doran Martell", house: "Martell")
        let olenna = Character(name: "Olenna Tyrell", house: "Tyrell")
        let mace = Character(name: "Mace Tyrell", house: "Tyrell")
        
        // edit our characters array to use our array from our data source
        dataSource.characters = [ned, arya, daenerys, rhaegar, obern, doran, olenna, mace].sorted(by: { $0.name < $1.name })
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // edit our characters array to use our array from our data source
        let character = dataSource.characters[indexPath.row]
        
        let ac = UIAlertController(title: character.name, message: character.house, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}
```

With that change, our view controller is now down to 44 lines. That's nearly half! It is now much easier to read through your view controller without filtering through the data that is shown. And if you need to edit the data itself, you don't even need to touch the view controller! But can we do better? Yes, we can...


### Creating a custom table view cell
Even though our data source is separated it contains some code that really isn't needed. Our `cellForForwAt` method is 29 lines long mainly because it's also configuring *how* the cell should look. This is where creating custom tableview cells comes in handy. 

Start by creating a new CocoaTouch file called `CharacterTableViewCell.swift` that inherits from UITableViewCell. This will create the following file:

```
class CharacterTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
```

Before we start adding stuff, we need to jump into Storyboard, select your tableview cell, select Identity Inspector,  and change its class to  `CharacterTableViewCell`. Now back to the code. Create the following setup function inside `CharacterTableViewCell`.

```
func setUp(with character: Character) {
    
}
```

We can add how we want our tableview cell to look inside of this, then call this function from our datasource. Since we are passing in a character as a parameter, we can use its values to edit the label, detail label, image, and background color. However, since this class inherits `UITableViewCell` we can leave off of every instance of `cell` and just call the method directly. Move that code over now so it looks like this.

```
func setUp(with character: Character) {
    textLabel?.text = character.name
    textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
    
    detailTextLabel?.text = character.house
    detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    
    if let image = UIImage(named: character.house.lowercased()) {
        imageView?.image = image
    }
    
    switch character.house.lowercased() {
    case "stark":
        backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
    case "tyrell":
        backgroundColor = UIColor(red: 144/255, green: 158/255, blue: 131/255, alpha: 1)
    case "targaryen":
        backgroundColor = UIColor(red: 155/255, green: 44/255, blue: 41/255, alpha: 1)
    case "martell":
        backgroundColor = UIColor(red: 227/255, green: 138/255, blue: 75/255, alpha: 1)
    default:
        break
    }
}
```

Then back in your data source class we  only need to make two changes. The first is casting how your cell is returned as the new tablecell we created. The second is calling our `setUp()` method while passing in our character. Edit `cellForRowAt` to look like this:

```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CharacterTableViewCell
    let character = characters[indexPath.row]
    
    cell.setUp(with: character)
    
    return cell
}
```

This brought our `cellForRowAt` method down to only 8 lines of code!

### Conclusion
This was a very simple project that showed you how to separate your UITableViewController to have a dedicated data source class and custom tableview cell. You'll find that in large projects, you can even reuse the custom cell view in multiple tableviews if needed, saving you from re-writing all of that code again. Although this creates multiple files, you'll know exactly where to go when you want to change/add/remove something. 

I hope you found this valuable and I encourage you to try it out in your next project. It's also easy enough to refractor your current project one view controller at a time.  If you want to see and/or download the final project you can do so [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift).
