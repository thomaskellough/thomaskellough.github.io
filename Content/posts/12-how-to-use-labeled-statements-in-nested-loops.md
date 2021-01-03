---
date: 2021-01-03 14:05
description: How to use labeled statements in nested loops
tags: LabeledStatements
---
# Use labeled statements to break out of nested loops

<div class="post-tags" markdown="1">
  <a class="post-category post-category-labeledstatements" href="/tags/labeledstatements">LabeledStatements</a>
</div>

This tip is not related to UIKit or SwiftUI. It's just a technique that focuses on the Swift language itself, so feel free to apply it to any projects you make. You can test this out in Swift Playgrounds; no need to start a new project. 

Let's start by creating a simple for loop in Swift that prints out the numbers 1 through 100. 

```
for i in 1...100 {
    print(i)
}
```

Then let's add a break clause that exits the loop when the number enters 50.

```
for i in 1...100 {
    print(i)
    if i == 50 {
        break
    }
}
```

Easy enough, right? However, let's add another loop inside of our first loop that prints out a through z after each iteration of our first loop. This means we will be print out `1, a, b, c, d, e, f, g, h, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z`  THEN `2, a, b, c, d, e, f, g, h, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z ` THEN `3, a, b, c, d, e, f, g, h, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z` and so on...

```
for i in 1...100 {
    print(i)
    for char in "abcdefghijklmnopqrstuvwxyz" {
        print(char)
    }
}
```

So far so good. Everything works as expected.  However, I want us to add a break statement in the second loop that breaks when we reach the letter `m`. But before you do, think for a minute about what  you should expect to see. When you're ready, give it a try.

```
for i in 1...100 {
    print(i)
    for char in "abcdefghijklmnopqrstuvwxyz" {
        print(char)
        if char == "m" {
            break
        }
    }
}
```

Now you probably came to one of the following conclusions

1) You will start by printing out 1, then each letter in the alphabet until you reach m. Then you will break out of both loops and stop printing completely.
2) You will start by printing out 1, then each letter in the alphabet until you reach m. Then you will break out of the alphabet (inner) loop, then print out 2, then a - m, then 3, then a - m, and so on. 

If you guessed the second option then you guessed correctly. We will break out of the inner loop, but we will never break out of the outer loop because we never specified that. More so, since `char` is used only in the scope of the inner loop, you don't have access to it on the outer loop. That means you cannot do something like this

```
for i in 1...100 {
    print(i)
    for char in "abcdefghijklmnopqrstuvwxyz" {
        print(char)
        if char == "m" {
            break
        }
    }
    if char == "m" {
        break
    }
}
```

One way to achieve the desired results is by creating a variable outside of the loop, editing it from inside the inner loop, then breaking out of the outer loop in a specific condition.

```
var isCharM = false
for i in 1...100 {
    print(i)
    for char in "abcdefghijklmnopqrstuvwxyz" {
        print(char)
        if char == "m" {
            isCharM = true
        }
    }
    if isCharM {
        break
    }
}
```
This works, but it's adding an extra variable that just opens up the potential to create more bugs. It can also get complicated if you have a lot of nested loops. Swift offers something a bit better called `labeled statements`. This means giving your loop a name, then specifying to break out of that loop on a certain condition. The name is given to the loop right before the `for` keyword and specified to be broken out after the `break` keyword.

```
outerLoop: for i in 1...100 {
    print(i)
    for char in "abcdefghijklmnopqrstuvwxyz" {
        print(char)
        if char == "m" {
            break outerLoop
        }
    }
}
```

This code looks much cleaner and is also easily readable. Note that the name of your loop can be anything you want. 

When is this useful? You may not ever need it in your projects. But knowing it's a possibility is always nice to know. Here is a better example of when it might be used instead of printing out numbers and letters.  

Say you are making a video game and you want to have a cheat code of "up, down, left, right, b, a". The controller has a handful of options that you can press such as `up`, `down`, `left`, `right`, `b`, `a`,  `start`, or `select`.  Let's create an array of each possibility then create a cheat code. We can then loop over each option in sequence and create an array to compare to the cheat code. I want to do one extra thing here and that's time our executions using `CFAbsoluteTimeGetCurrent`. 

```
let choices = ["up", "down", "left", "right", "b", "a", "start", "select"]
let cheatCode = ["up", "down", "left", "right", "b", "a"]

let startTime = CFAbsoluteTimeGetCurrent()

for firstChoice in choices {
    for secondChoice in choices {
        for thirdChoice in choices {
            for fourthChoice in choices {
                for fifthChoice in choices {
                    for sixthChoice in choices {
                        let sequence = [firstChoice, secondChoice, thirdChoice, fourthChoice, fifthChoice, sixthChoice]
                        
                        if sequence == cheatCode {
                            print("Powerup enabled!")
                        }
                    }
                }
            }
        }
    }
}

let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Checking for cheatcode code took \(timeElapsed) seconds")
```
When you run this you'll so that we print out "Powerup enabled!" and continue running for a total time of 12.37 seconds (on my machine, anyway). It looped for a total number of 262,144 times.

After adding a labeled statement and breaking out once the cheatcode was hit, it cut my time down to 0.28 seconds and the total number of loops to 5,350. 

```
outerLoop: for firstChoice in choices {
    for secondChoice in choices {
        for thirdChoice in choices {
            for fourthChoice in choices {
                for fifthChoice in choices {
                    for sixthChoice in choices {
                        let sequence = [firstChoice, secondChoice, thirdChoice, fourthChoice, fifthChoice, sixthChoice]
                        
                        if sequence == cheatCode {
                            print("Powerup enabled!")
                            break outerLoop
                        }
                    }
                }
            }
        }
    }
}

let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Checking for cheatcode code took \(timeElapsed) seconds")
```

I hope you can find value in using Swift's labeled statements. As I said earlier, it might not be something you ever use, but it's something nice to know if you ever run into a situation that needs it. 
If you get bored, try the full Konami code of `up, up, down, down, left, right, left, right, b, a, start`. You'll be surprised by how long it takes :)
