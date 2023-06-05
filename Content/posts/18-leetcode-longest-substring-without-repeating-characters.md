---
date: 2023-06-01 14:30
description: Longest Substring Without Repeating Characters.
tags: LeetcodeMedium
---
# Longest Substring Without Repeating Characters

<div class="post-tags" markdown="1">
    <a class="post-category post-category-leetcodemedium" href="/tags/leetcodemedium">Leetcode Medium</a>
</div>

### Problem
[Majority Element](https://leetcode.com/problems/longest-substring-without-repeating-characters/) is a medium-tagged leetcode problem. It's problem statement is:

<div class="problem-container">Given a string s, find the length of the longest substring without repeating characters.
</div>

### Thought Process
When approaching this problem, it's important to clarify what we mean by "repeating characters." In this context, it refers to any characters that have appeared previously in the substring, regardless of their order. It's essential to understand this distinction to ensure we solve the problem correctly.

Now, let's consider our approach:

1. Sets: Sets are an excellent choice for storing unique information without considering the order. Adding and removing elements from a set can be done in constant time O(1), making them advantageous over arrays.
2. Sliding Window: The sliding window technique is a powerful approach for solving substring problems efficiently. It allows us to track and adjust the substring's boundaries dynamically, focusing only on the relevant substring rather than checking every possible substring.

By combining sets and the sliding window technique, we can optimize our solution for this problem and achieve an efficient and elegant solution.

### Solution

#### What we are given

```
func lengthOfLongestSubstring(_ s: String) -> Int {
    
}
```

#### First steps and edge cases
I like to focus on edge cases first. We notice the `String` is not optional, so no nil checks are needed. However, we could have an empty string or a string with one character in it. This means we need at least two characters before we even perform logic. We can handle our edge cases like so:

```
guard s.count > 1 else { return s.count }
```

Next, we can set up the necessary variables. We'll need a leftPointer and a rightPointer to track the boundaries of the sliding window. We'll also initialize maxLength to 0 to keep track of the maximum length of the substring. Lastly, we can convert the string into an array to make it easier to work with:

```
let arr = Array(s)

var leftPointer = 0
var rightPointer = 0

var maxLength = 0
var uniqueCharacters = Set<Character>()
```

Now, let's move on to the main logic. Since we're using the sliding window technique, we'll iterate over the array once, stopping when the rightPointer reaches the end of the array:

```
while rightPointer < arr.count {

}
```

Inside the loop, we'll perform a check. We'll determine if the character at the current rightPointer index exists in the uniqueCharacters set. Depending on the result, we'll take different actions. We'll continue building the logic inside the if and else blocks in the next steps:

```
while rightPointer < arr.count {
  if uniqueCharacters.contains(arr[rightPointer]) {
  
  } else {
  
  }
}
```

Now, let's discuss what happens inside the loop. First, we check if the character at the current rightPointer index is already present in the uniqueCharacters set. If it is, we have encountered a duplicate character.

In that case, we remove the character at the leftPointer index from the uniqueCharacters set, as it is no longer part of the current substring. We increment the leftPointer to move the sliding window to the right, excluding the duplicate character. This ensures that the leftPointer will never be greater than the rightPointer.


```
while rightPointer < arr.count {
  if uniqueCharacters.contains(arr[rightPointer]) {
    uniqueCharacters.remove(arr[leftPointer])
    leftPointer += 1
  } else {
  
  }
}
```

If the character at the current rightPointer index is not present in the uniqueCharacters set, it is a new character that we haven't encountered before in the current substring.

In this case, we insert the character into the uniqueCharacters set, indicating that it is part of the current substring. We increment the rightPointer to expand the sliding window to the right and include the new character. We also update the maxLength by calculating the difference between the rightPointer and leftPointer indices and taking the maximum value.

```
while rightPointer < arr.count {
  if uniqueCharacters.contains(arr[rightPointer]) {
    uniqueCharacters.remove(arr[leftPointer])
    leftPointer += 1
  } else {
    uniqueCharacters.insert(arr[rightPointer])
    rightPointer += 1
    maxLength = max(maxLength, rightPointer - leftPointer)
  }
}
```

Finally, after the loop ends, we have processed the entire string, and the maxLength variable holds the length of the longest substring without repeating characters. We return the maxLength as the result.

```
func lengthOfLongestSubstring(_ s: String) -> Int {
    guard s.count > 1 else { return s.count }

    let arr = Array(s)

    var leftPointer = 0
    var rightPointer = 0

    var maxLength = 0
    var uniqueCharacters = Set<Character>()

    while rightPointer < arr.count {
      if uniqueCharacters.contains(arr[rightPointer]) {
        uniqueCharacters.remove(arr[leftPointer])
        leftPointer += 1
      } else {
        uniqueCharacters.insert(arr[rightPointer])
        rightPointer += 1
        maxLength = max(maxLength, rightPointer - leftPointer)
      }
    }

    return maxLength
}
```

This completes our solution to find the length of the longest substring without repeating characters using the sliding window approach. Since we have to loop through the string once, we have a time complexity of O(n). We also have a set that can, worst case, have the same number of elements as our string. This means we also have a space complexity of O(n).
