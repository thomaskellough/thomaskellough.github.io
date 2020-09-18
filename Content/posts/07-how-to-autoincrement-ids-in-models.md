---
date: 2020-09-18 14:48
description: Creating a list of custom objects can pose challenges. Here we explain how to make it a bit easier by automatically incrementing ID's for each object.
tags: Structs, Codable, Extensions
---
# Automatically incrementing id's inside a list of custom objects.

<div class="post-tags" markdown="1">
        <a class="post-category post-category-structs" href="/tags/structs">Structs</a>
        <a class="post-category post-category-codable" href="/tags/codable">Codable</a>
        <a class="post-category post-category-extensions" href="/tags/extensions">Extensions</a>
</div>


### Creating a list of objects
Let's say you have a basic JSON list that looks like this:

```
[
  {
    "id" : 1,
    "name" : "Harry Potter",
    "house" : "Gryffindor"
  },
  {
    "id" : 2,
    "name" : "Hermione Granger",
    "house" : "Gryffindor"
  },
  {
    "id" : 3,
    "name" : "Draco Malfoy",
    "house" : "Slytherin"
  },
  {
    "id" : 4,
    "name" : "Luna Lovegood",
    "house" : "Ravenclaw"
  },
  {
    "id" : 5,
    "name" : "Cedric Diggory",
    "house" : "Hufflepuff"
  }
]

```
This holds a students name, the house they are in, and a custom ID. To create something like this in Swift you might create the following struct:

```
struct Student: Codable {
    let id: Int
    let name: String
    let house: String
}
```

Then you can add each student like so:

```
let harry = Student(id: 1, name: "Harry Potter", house: "Gryffindor")
let hermione = Student(id: 2, name: "Hermione Granger", house: "Gryffindor")
let draco = Student(id: 3, name: "Draco Malfoy", house: "Slytherin")
let luna = Student(id: 4, name: "Luna Lovegood", house: "Ravenclaw")
let cedric = Student(id: 5, name: "Cedric Diggory", house: "Hufflepuff")

let students: [Student] = [harry, hermione, draco, luna, cedric]
```

This works just fine. But imagine adding more and more students. How do you remember everyone's `id`? When you are registering each student, you're not expected to know the latest `id`. The only thing *you* need to know is their name and house they belong in. So how can we have an `id` that's created automatically?

You could create a variable for `id` and pass that in like this:

```
var studentID = 1

let harry = Student(id: studentID, name: "Harry Potter", house: "Gryffindor")
studentID += 1
let hermione = Student(id: studentID, name: "Hermione Granger", house: "Gryffindor")
studentID += 1
let draco = Student(id: studentID, name: "Draco Malfoy", house: "Slytherin")
studentID += 1
let luna = Student(id: studentID, name: "Luna Lovegood", house: "Ravenclaw")
studentID += 1
let cedric = Student(id: studentID, name: "Cedric Diggory", house: "Hufflepuff")
```

And this would actually work. But it looks messy, right? A better way is to create a custom initializer in your struct that can automatically apply the id for you and automatically increment. This is done by editing your `Student` struct to look like this:

```
var studentID = 1

struct Student: Codable {
    let id: Int
    let name: String
    let house: String
    
    init(name: String, house: String) {
        self.id = studentID
        self.name = name
        self.house = house
        
        studentID += 1
    }
}
```

Now when you add students you can actually leave the `id` parameter off completely and it will be taken care of behind the scenes.

```
let harry = Student(name: "Harry Potter", house: "Gryffindor")
let hermione = Student(name: "Hermione Granger", house: "Gryffindor")
let draco = Student(name: "Draco Malfoy", house: "Slytherin")
let luna = Student(name: "Luna Lovegood", house: "Ravenclaw")
let cedric = Student(name: "Cedric Diggory", house: "Hufflepuff")
```
### Bonus
If you want to print out your JSON in a pretty format here is a nice extension that helps with that. It deserializes your object into a formatted NSString.

```
extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

let jsonData = try JSONEncoder().encode(students)
let jsonString = String(data: jsonData, encoding: .utf8)!
let prettyString = jsonString.data(using: .utf8)!.prettyPrintedJSONString!
print(prettyString)
```
