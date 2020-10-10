---
date: 2020-10-10 14:48
description: Learn how to implement UISearchController in your apps to help users search through content easier.
tags: UISearchController, UIKit
---
# Using UISearchController with UIKit

<div class="post-tags" markdown="1">
    <a class="post-category post-category-uisearchcontroller" href="/tags/uisearchcontroller">UISearchController</a>
    <a class="post-category post-category-uikit" href="/tags/uikit">UIKit</a>
</div>


### Getting started
Go ahead and download the starter project [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift).  If you don't want to download the starter project, just simply make your own tableview embedded in a navigation controller with some pre-populated data. I recommend adding a title and subtitle to your tableview so we can search by two different things, but this tutorial will use my starter project in all the examples.

Great! So now we have a tableview that lists different Hogwarts students as well as their appropriate houses. I also color-coded it so make it easier to see what's happening. If you're using the start project and you run it you should see something like this:

<img class="post-image img-sm" src="/Images/Posts/08/08-01.png" alt="Hogwarts Student TableView"/>

This is created from the following code assuming you have storyboard set up

```
import UIKit

class TableViewController: UITableViewController{
   
  var students = [Student]()
   
  override func viewDidLoad() {
    super.viewDidLoad()
     
    createStudents()
  }
   
  func createStudents() {
    let harry = Student(name: "Harry Potter", house: "Gryffindor")
    let hermione = Student(name: "Hermione Granger", house: "Gryffindor")
    let ron = Student(name: "Ronald Weasley", house: "Gryffindor")
    let luna = Student(name: "Luna Lovegood", house: "Ravenclaw")
    let ginny = Student(name: "Ginny Weasley", house: "Gryffindor")
    let fred = Student(name: "Fred Weasley", house: "Gryffindor")
    let george = Student(name: "George Weasley", house: "Gryffindor")
    let neville = Student(name: "Neville Longbottom", house: "Gryffindor")
    let dean = Student(name: "Dean Thomas", house: "Gryffindor")
    let draco = Student(name: "Draco Malfoy", house: "Slytherin")
    let parvati = Student(name: "Parvati Patil", house: "Gryffindor")
    let padma = Student(name: "Padma Patil", house: "Ravenclaw")
    let cedric = Student(name: "Cedric Diggory", house: "Hufflepuff")
    let hannah = Student(name: "Hannah Abbott", house: "Hufflepuff")
    let zacharias = Student(name: "Zacharias Smith", house: "Hufflepuff")
    let crabbe = Student(name: "Vincent Crabbe", house: "Slytherin")
    let goyle = Student(name: "Gregory Goyle", house: "Slytherin")
     
    students += [harry, hermione, ron, ginny, fred, george, luna, neville, dean, draco, parvati, padma, cedric, hannah, zacharias, crabbe, goyle]
  }
   
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
     
    let student = students[indexPath.row]
     
    cell.textLabel?.text = student.name
    cell.detailTextLabel?.text = student.house
    cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
    cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
    cell.textLabel?.textColor = .white
    cell.detailTextLabel?.textColor = .white
     
    switch student.house {
    case "Gryffindor":
      cell.backgroundColor = UIColor(red: 174/255, green: 0, blue: 1/255, alpha: 1)
    case "Ravenclaw":
      cell.backgroundColor = UIColor(red: 34/255, green: 47/255, blue: 91/255, alpha: 1)
    case "Hufflepuff":
      cell.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 0, alpha: 1)
      cell.textLabel?.textColor = .black
      cell.detailTextLabel?.textColor = .black
    case "Slytherin":
      cell.backgroundColor = UIColor(red: 42/255, green: 98/255, blue: 61/255, alpha: 1)
    default:
      break
    }
     
    return cell
  }
   
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    students.count
  }

}

struct Student {
  var name: String
  var house: String
}

```

The first step is to create the UISearchController and add it to the navigation bar. This is done with the following lines of code inside of your `viewDidLoad` method.

```
let searchController = UISearchController(searchResultsController: nil)
searchController.searchResultsUpdater = self
searchController.obscuresBackgroundDuringPresentation = false
searchController.searchBar.placeholder = "Search..."
navigationItem.searchController = searchController
```

Now your app won't compile, but it's an easy fix. The reason is because we now need to confrom to the `UISearchResultsUpdating` protocol. So add that protocol now as well as a the following protocol stub that we will look at later.

```
class ViewController: UITableViewController, UISearchResultsUpdating {
  .....
  
  func updateSearchResults(for searchController: UISearchController) {
      // will fill in later
  }
}
```

When you run your app now you should see a UISearchController inside your app, but it won't do anything yet!

<img class="post-image img-sm" src="/Images/Posts/08/08-02.png" alt="Hogwarts Student TableView With UISearchController" width="800"/>

### Setting up filtering
There is a trick to filtering your data if you want it to be reusable. Think about it this way. You have a list of something, you filter that list and get a new list back, and you can repeat the process as much as you want. But want if you want all items in the list back? You've already filtered out items so they don't exist anymore! We can solve this by creating *two* lists. One list will hold all items while the other will be a filtered list.

Add the following property below your students array at the top of your code.

```
var filteredStudents = [Student]()
```

Then we want to set up our app to read from `filteredStudents` instead of `students`. But we also need to set `filteredStudents`. Go ahead and set `filteredStudents` at the bottom of `createStudents()` by adding

```
filteredStudents = students
```

Then change your `cellForRowAt` method to be

```
let student = filteredStudents[indexPath.row]
```

Last, change `numberOfRows` in section to 

```
filteredStudents.count
```

You should be able to run your app now and see the same thing as before, but the UISearchController still won't work!

### Making the filtering work
Here's where we make the magic happen. We need to do a few different things to make our data filterable.

1) We need to create a variable that allows us to hold the text we want to filter by.

2) We need to call update our `updateSearchController` function that changes the variable created in step 1 to what the user types in

3) We need to filter our `filteredStudents` array every time we set our filtered text in step 2

4) We need to update our tableview every time the filter text gets set and the `filteredStudents` array gets filtered

Wow, that can be wordy. But let's do it one step at a time.

#### 1) Create a variable that allows us to hold the text we want to filter by
Easy enough, add the following at the top of your class function.
```
var filterText: String = ""
```

#### 2) Change `updateSearchController` to edit the variable as the user types

```
func updateSearchResults(for searchController: UISearchController) {
    if let text = searchController.searchBar.text {
        filterText = text
    }
}
```
*Note: I choose to unwrap the text here so I don't have to unwrap it later. It's your choice!*

#### 3) Filter our `filteredStudents` array everytime `filteredText` is set.
This is done easily enough by using a `didSet` method on our variable. This means that every time we set the variable, we can do something else. Edit `filteredText` to look like this.
```
var filterText: String = "" {
    didSet {
        filteredStudents = students.matching(filterText)
    }
}
```

This code won't run yet, because we don't have a `matching` function. We can create an extension on `Array` that allows us to pass in a string to help filter our array. Note that we don't need to unwrap here since it was done in step 2. The extension does a couple of things. 

1) Takes in a string and returns a student array `[Student]`.

2) If the text has a count greater than 0, or *something* we can filter by, call the `filter()` function that arrays already have. If you want to keep it case-insensitive then make sure you lowercase both the element in the array as well as the text passed in. This is the section where you can add any kind of logic you want. In this example, we will filter by name OR house using the || operator. 

3) If `text.count` is equal to zero it means there is nothing written in the UISearchController so just return the full array. Add this extension now.

```
extension Array where Element == Student {
  func matching(_ text: String) -> [Student] {
    if text.count > 0 {
      return self.filter {
        $0.name.lowercased().contains(text.lowercased()) || $0.house.lowercased().contains(text.lowercased())
      }
    } else {
      return self
    }
  }
}
```

#### 4) Update our tableview everytime the filter text gets set and `filteredStudents` array gets filtered.
This part can be done a couple of ways. The easiest way is to call `self.tableView.reloadData()` inside of your did set.

```
var filterText: String = "" {
  didSet {
    filteredStudents = students.matching(filterText)
    self.tableView.reloadData()
  }
}
```

Another, and arguably better option, is to create a closure that gets called when `filterSet` is set and give that closure a method in `viewDidLoad`. This is helpful if you have your data source separated from your view controller. If you want to go that route then add the following variable and edit `filterText` to this.

```
var dataChanged: (() -> Void)?
var filterText: String = "" {
  didSet {
    filteredStudents = students.matching(filterText)
    dataChanged?()
  }
}
```

Then inside of `viewDidLoad` you can set `dataChanged` like this.

```
dataChanged = {
  self.tableView.reloadData()
}
```

<img class="post-image img-sm" src="/Images/Posts/08/08-05.gif" alt="Filtering gif" width="800"/>
   

Whichever method you choose, you should be good to go! Go ahead and run the app now and you should be able to filter in real-time. Feel free to also take a look at the full project [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift).
