---
date: 2020-11-07 14:48
description: Learn how to use unit testing in your apps to help you write better and safer code
tags: Unit Testing, UIKit
---
# Unit Testing with UIKit

<div class="post-tags" markdown="1">
  <a class="post-category post-category-unittesting" href="/tags/unittesting">Unit Testing</a>
  <a class="post-category post-category-uikit" href="/tags/uikit">UIKit</a>
</div>


### Introduction
Unit testing is highly valuable when making apps. Yet, there are so many apps in production that don't use it. It can help you write code that is stronger and more clear, help prevent app crashes, help reduce the re-opening of Jira tickets when the QA team finds an issue and can help you debug your code without running the app. So seriously, what's not to like? Why don't people use it?

One of the reasons is people don't understand how to use unit testing. It seems weird to write simple tests for something that you *know* will work, right? Maybe so, but when you have multiple developers working on the same team you're not all working on the same stuff. It's very easy for someone to accidently disrupt the code that you wrote previously. It also takes time to write unit testing. Not a whole lot, but more than none, and many people are rushed. However, neglecting to use unit tests can cause more time spent later on by fixing the bugs that would have been found by simply pressing `cmd + u`. 


### Setup
If you want to set up your own project that's fine. Create some text fields in the main view for first name, last name, date of birth, and 4-dig pin inputs. Then add a submit button at the bottom. Or you can download the starter project [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift).

For reference, here is what you get when you run the starter, and here is what the code looks like.

<img class="post-image img-sm" src="/Images/Posts/10/10-01.png" alt="Unit Testing Starter"/>

```
import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var dateOfBirthTextField: UITextField!
  @IBOutlet weak var pinNumberTextField: UITextField!
   
   
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func validateTapped(_ sender: Any) {
     
  }
   
}
```

As you can see, there isn't much going on at the moment. The idea of the app is to have a user type in their first name, last name, date of birth, and PIN then hit validate. Although this app does nothing, it's a great way to see how unit testing works. 

Before we can start, we need to add unit testing to our project. Now, if you start the project from scratch, you can check a box that says "Unit Testing". And I recommend doing this with all your projects. However, it's not impossible to add unit testing to already existing projects that don't already incorporate it. To do this, go to `File > New > Target` then filter for `Unit Testing Bundle` and add it to your project target. There should only be one, but if you have multiple targets in your project then you will need to add multiple unit tests.

<img class="post-image" src="/Images/Posts/10/10-02.png" alt="File Tree Unit Testing"/>

<img class="post-image" src="/Images/Posts/10/10-03.png" alt="Unit Testing Bundle"/>

<img class="post-image" src="/Images/Posts/10/10-04.png" alt="Project Directy After Adding Unit Testing"/>

### Writing Your First Test
Now you'll often hear the term `Test-Driven Development`. Many people take this approach because it helps you understand your code and ensure your tests are working. The steps, in short, are

1) Write a failing test

2) Run the code, ensure your code fails (What? Yes, for real)

3) Write the code to make the test pass

4) Run your tests again

5) Refractor as needed

Let's start with writing a failing test. You'd think we need to jump into our new unit testing Swift file, but we can't do that yet. Mainly because the way we will validate our fields will be by using extensions. We can't test a function or property that doesn't exist. Instead, I want you to create a new folder inside your project directory called `Extensions`. The purpose of the new folder is purely for better organization. Inside the new folder, create a swift file called `String+Extensions`. Note here, when you add the file you do NOT need to check the box for your unit testing target. Only check the box for the main project target.

Let's start with testing the first name input that the user tries to validate. However, we are going to make it return false since that's the first step to test-driven development. 

Create a new `String` extension property below. 
*Note - You can do this using properties or functions. I prefer a property for this, but it's your choice*

```
extension String {
  var isValidFirstName: Bool {
    return false
  }
}
```

While we are on extensions, create a new one for `UITextField` to show our invalid and valid fields. Of course, feel free to edit them as you see fit.

```
extension UITextField {
  func invalidate() {
    backgroundColor = .red
    textColor = .white
  }
   
  func validate() {
    backgroundColor = .systemBackground
    textColor = .label
  }
}
```

Now let's write our first test. Head over to `How_To_Use_Unit_TestingTests.swift` and take a look at what you see.

```
import XCTest

class How_To_Use_Unit_TestingTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }

}
```

The `setUpWithError()` and `tearDownWithError()` are two functions that get called before and after (respectively) every single test is run. For this project, we don't need it because we are only testing extension properties. The `testExample()` can be removed and the `testPerformanceExample()` can also be removed. The latter will time your code so you can refractor and improve costly calculations. This is beyond the scope of this tutorial. 

Before we can start testing and using our functions, we need to add one line of code towards the top. Under `import XCTest` add the following.

```
@testable import How_To_Use_Unit_Testing
```

This allows us to test our project and use any functions and extensions that we wrote for it.

When we write a test, you need to name the function a specific way. It needs to start with `test` then you can fill in the rest how you want. There are various naming conventions, and you can choose the one you like. Personally, I like to name it `test(what am I testing)_(what should the result be)`. Then, to check our result, we use the `XCTAssert` function. There are many to choose from, and often, you can choose the one you want. You can use `XCTAssert` for everything and type in your conditions yourself. However, I like to be explicit. Since we are validating something is true, let's use `XCTAssertTrue()`. Let's write our first test for a passing first name

```
func testFirstNameHarryIsValid_True() {
  let name = "Harry"
  let isValid = name.isValidFirstName
  XCTAssertTrue(isValid, "Uh oh! \(name) is not valid")
}
```

Now, either press `cmd + u` to run your test or press the diamond next to the function (or the class to run all tests). You should see this.

<img class="post-image" src="/Images/Posts/10/10-05.png" alt="Failing Test"/>

Oh no! Our test failed! However, that was expected. At this point, we should go correct our string extension to help us pass our test. But before we do that, I want you to navigate to `viewController.swift`, and let's add some code. I want you to see it failing in the app first, then we can finish the tests. Inside `viewController.swift`, edit your button tapped function. We want to check for validation, and if it's invalid set up an alert as we well as highlight which text field is invalid. This means we want to create a bool variable as true, but turn it to false if our textfield is invalid. Let's also add some color to our textfield so it's easier for the user to know which textfield is invalid. Edit your function in `viewDidLoad` to look like this

```
@IBAction func validateTapped(_ sender: Any) {
  var validForm = true
   
  if let firstName = firstNameTextField.text {
    if !firstName.isValidFirstName {
      validForm = false
      firstNameTextField.invalidate()
    }
  } else {
    validForm = false
    firstNameTextField.invalidate()
  }
   
  var title = ""
  var message = ""
  if validForm {
    title = "Success!"
    message = "All of your forms are valid"
  } else {
    title = "Oops!"
    message = "Some fields are invalid. Please correct and resubmit."
  }
   
  let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
  ac.addAction(UIAlertAction(title: "OK", style: .default))
  present(ac, animated: true)
}
```

Let's discuss what this does. 

1) Create a bool that starts as true

2) Check to see if the textfield contains text. If it doesn't mark the form as invalid and also invalidate the text field.

3) If it is valid, continue without doing anything

4) Once all validation is complete, show an alert either saying everything is valid or telling the user to correct their mistake and resubmit.

As you can guess, we should have an invalid form when we are finished. After all, our string extension returns `false`.

<img class="post-image" src="/Images/Posts/10/10-06.gif" alt="First Name Invalidation"/>

### Making Our Test Pass
Now let's head back over to `String+Extension` and help our test pass. It comes down to you, as the programmer, on what you want to allow to pass. Every app and be different, although, you will probably be able to reuse some functions. We will write some very basic validation steps for the purpose of this app. We will make sure that `firstName` is only characters. We will add a bit of spice to make it case-insensitive, though. Edit `isValidFirstName` to look like this.

```
var isValidFirstName: Bool {
  guard self.count > 0 else { return false }
  let array = Array(self.lowercased().trimmingCharacters(in: .whitespaces))
  let characters = "abcdefghijklmnopqrstuvwxyz"
  for character in array {
    if !characters.contains(character) {
      return false
    }
  }
   
  return true
}
```

1) This will check to see if the string contains at least something, or return false

2) Then it creates an array of all the characters in the string 

3) Create a string of characters we want to be valid

4) Loop through our array of characters, if our valid character contains the character being checked, do nothing. If it doesn't, bail and return false. 

5) If we make it through the end, it means all characters are valid so we can return true. 

You should be able to run your test now and see it pass. Here are a couple more tests that you can use. Note that you should also test false cases. There is no such thing as too many tests!!!

```
func testFirstNamehermioneIsValid_True() {
  let name = "hermione"
  let isValid = name.isValidFirstName
  XCTAssertTrue(isValid, "Uh oh! \(name) is not valid")
}
func testFirstNameRon5IsValid_False() {
  let name = "Ron5"
  let isValid = name.isValidFirstName
  XCTAssertFalse(isValid, "Uh oh! \(name) is not valid")
}
```

### Writing Date of Birth Test
Remember to start with a failing test. Here's my `String` extension as well as my first test case.

```
var isValidDOB: Bool {
  return false
}

func testDobIsValid1_True() {
  let dob = "07/31/1980"
  let isValid = dob.isValidDOB
  XCTAssertTrue(isValid)
}
```

After verifying my test fails, it's time to correct the `String` property. Note that we do not have to run our app right now. We can do that at the very end after all of our test cases! Now there are many ways to test date of birth. And honestly, letting a user manually type it in will only cause you more trouble than it's worth. It's better to use a picker so they pretty much have to enter it in the format that you want. However, for the purpose of this tutorial, we will be checking for one format. Edit `isValidDOB` to this. Here is also another test case you can use.

```
var isValidDateOfBirth: Bool {
  let formatter = DateFormatter()
  formatter.dateFormat = "MM/dd/yyyy"
   
  return formatter.date(from: self) != nil && self.count > 8
}

func testDobIsValid1_False() {
  let dob = "07/31/80"
  let isValid = dob.isValidDOB
  XCTAssertFalse(isValid)
}
```

Once again, add more tests, keep refractoring the code to what you want.

### Writing PIN number test
A valid PIN should be four digits long and contain only numbers. This is very easy to do if you know the shortcut. We can test the string for a count == 4, then see if it contains only numbers. Most people go in the same direction we took with the name, by creating an array of digits, looping through the string, comparing each loop through the array of digits, and react accordingly. This works, sure. But it's more code than is needed. Instead, let's use some Swift skills! Swift gives you the option to convert any string into an Integer. However, you can't convert something like `firebolt` to a number. So when you try this in Swift, it returns a `nil` value. So let's check if we can convert our string to an integer, and then we can return `true/false` based on if we get a nil value or not. Here is the `String` extension as well as some test cases for you.

```
var isValidPin: Bool {
  return self.count == 4 && Int(self) != nil
}

func test1234IsValid_True() {
  let pin = "1234"
  let isValid = pin.isValidPin
  XCTAssertTrue(isValid)
}

func test12345IsValid_False() {
  let pin = "12345"
  let isValid = pin.isValidPin
  XCTAssertFalse(isValid)
}

func testa234ISValid_False() {
  let pin = "a234"
  let isValid = pin.isValidPin
  XCTAssertFalse(isValid)
}
```

### Conclusion

And there you have it! You can now write your code and ensure you get the results you want. Note that you didn't even have to start anything in `viewController.swift` yet. Of course, you'll want to test it in simulator or a real device before deploying, but I hope you see how using Unit Testing can help you become a better programmer and save headaches in the future. In your own projects, you should write as many unique test cases as you can think of and run your tests often. If you are adding test cases to an already existing project that doesn't contain them, you may find it difficult and "not worth it". Just add them sporadically as you work on something relevant. If you want to see and/or download the final project you can do so [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift).
