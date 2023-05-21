---
date: 2023-05-21 14:30
description: Majority Element.
tags: LeetcodeEasy
---
# Majority Element

<div class="post-tags" markdown="1">
    <a class="post-category post-category-leetcodeeasy" href="/tags/leetcodeeasy">Leetcode Easy</a>
</div>

### Problem
[Majority Element](https://leetcode.com/problems/majority-element/) is an easy-tagged leetcode problem. It's problem statement is:

<div class="problem-container">Given an array nums of size n, return the majority element.

The majority element is the element that appears more than ⌊n / 2⌋ times. You may assume that the majority element always exists in the array.
</div>

### Thought Process
A couple of things to note....

1. We *must* return a number. There is no option to to return nil here.
2. According to the problem, the majority element will always exist. This means we *must* have at least one element in the array. If there is only one element in the array, we can return that element. To take this a step further, if there are two elements in the array, they must be the same because we cannot have a tie in this problem.

That being side, let's handle our edge cases here. We can actually handle both these with one line using Swift.

```
func majorityElement(_ nums: [Int]) -> Int {
    guard nums.count > 2 else { return nums.first! }
}
```

This is leetcode, not a real-world production problem. It is okay to force unwrap here because of our problem statement, but I would mention why you are doing this to your interviewer and discuss safer ways to handle this in real scenarios.

Next, we can move onto how to solve this if we have more than three elements in the array. Let's take and example array.

```
[1, 1, 1, 2, 2, 3, 1, 1, 2, 3, 1]
```

The first thought may be to start looping through the array and counting each number. It's not a bad idea and we should give it a try. The best way to count each element is to store each value in a dictionary. We can start by looping through the array and incrementing each element by one when we run into it.


```
var dict = [Int: Int]()

for num in nums {
    if let _ = dict[num] {
        dict[num]! += 1
    }  else {
        dict[num] = 1
    }
}
```

Then we can loop over the dictionary, compare it's value to [n / 2], then return the key to that value.
```
for (key, value) in dict {
    if value > nums.count / 2 {
        return key
    }
}

return -1
```

### Solution 1

The full solution is:

```
func majorityElement(_ nums: [Int]) -> Int {
    guard nums.count > 2 else { return nums.first! }

    var dict = [Int: Int]()

    for num in nums {
        if let _ = dict[num] {
            dict[num]! += 1
        }  else {
            dict[num] = 1
        }
    }

    for (key, value) in dict {
        if value > nums.count / 2 {
            return key
        }
    }

    return -1
}
```

Runtime - 105 ms
Memory - 15.9 MB

This is a perfectly valid solution. It's fast and uses little memory. Since we only need to loop through the array once and then the dictionary once we have a time complexity of O(n). Since we store data in a hashmap we also have a space complexity of O(n). For most jobs interviews, this solution is probably sufficient. However, let's discuss a couple of ways to make this a bit better.

The first way is a way to show you your Swift knowledge. Swift's dictionary has a built-in way to increment a current value OR create a new key/value pair if it does not exist.

This means we can update our looping of our array to the following:

```
for num in nums {
    dict[num, default: 0] += 1
}
```

### Solution 2

To take this one step further, we can make this method a bit quicker by checking the value each time after updating our array. This saves us from looping through the dictionary after the fact.

```
func majorityElement(_ nums: [Int]) -> Int {
    guard nums.count > 2 else { return nums.first! }

    var dict = [Int: Int]()

    for num in nums {
        dict[num, default: 0] += 1

        if dict[num]! > nums.count / 2 {
            return num
        }
    }

    return -1
}
```

It's safe to force unwrap here because we are ensuring that we have a value in the line literally above it.

Runtime - 105 ms
Memory - 15.9 MB

Note that the runtime and memory are very similar to solution 1. In fact, even though this can be faster, it still has a time and space complexity of O(n). When calculating for time and space complexity we always do it with worst case scenario. In this example, as n increases so does both our time and space.

*Tip: if you want to further use Swift syntatic sugar, look into ```forEach```*


### Solution 3
I still think both above solutions are great solutions, but we can actually improve both our space and complexity if we desire. The caveat is that it involves sorting. Depending on your interviewer, you may be allowed to use built-in sort methods, but some will prefer you not to. I doubt it would be in issue with this problem because that's not the goal, so be sure to discuss with them what you want to do and see if they are okay with it.

Let's take the following array:

```
[1, 1, 2, 2, 3, 3, 2, 1, 1, 2, 3, 1, 1, 1, 2, 1]
```

If we were to sort this array we would get

```
[1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3]
```

If we look at the middle element we get 1. For this problem, after sorting the array we will *always* get the majority element.

This means we can solve this problem in literally one line of Swift code.

```
func majorityElement(_ nums: [Int]) -> Int {
    return nums.sorted()[nums.count / 2]
}
```

Runtime - 99 ms
Memory - 15.6 MB

Much faster and uses less memory. This is because [Swift's sort method](https://github.com/apple/swift/blob/main/stdlib/public/core/Sort.swift) has a time complexity of O(nlogn). The space complexity for this problem is O(1) since we do not use any additional space.

If you were to get this problem in an interview, I would recommend discussing this method and one of the previous methods where you loop yourself. This one is obviously the better solution, but the interviewer may be sure you understand coding basics such as dictionaries and looping.
