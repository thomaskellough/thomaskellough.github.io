---
date: 2023-06-04 14:30
description: Merge Two Sorted Lists
tags: LeetcodeEasy
---
# Merge Two Sorted Lists

<div class="post-tags" markdown="1">
    <a class="post-category post-category-leetcodeeasy" href="/tags/leetcodeeasy">Leetcode Easy</a>
</div>

### Problem
[Merge Two Sorted Lists](https://leetcode.com/problems/merge-two-sorted-lists/) is an easy-tagged leetcode problem. It's problem statement is:

<div class="problem-container">You are given the heads of two sorted linked lists list1 and list2.

Merge the two lists in a one sorted list. The list should be made by splicing together the nodes of the first two lists.

Return the head of the merged linked list.
</div>

### Understanding the Problem
The problem requires us to merge two sorted linked lists into a single sorted list. To tackle this problem, we need to be familiar with linked lists and recursion. While some may consider this problem to be easy, it can be a bit challenging if you are not comfortable with these concepts. In this tutorial, I'll show you how to use recursion to solve this problem effectively.

### Solution
Let's start by examining the provided code:

```
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */
class Solution {
    func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        
    }
}
```

The first thing to look at is what our linked list is. It has a value and a next node. This is a singly-linked list since we do not have any access to the previous node. Second, the function `mergeTwoLists` takes in two optional lists as arguments and returns an optional linked *node*. The optionality is great here and we can use it to our advantage with recursion.

To begin, we should handle the edge cases upfront, especially since we plan to use recursion. Failing to handle these cases properly can lead to infinite loops. In this problem, the edge cases are quite simple: if either of the lists is nil, we return the other list. If both lists are not nil, we proceed with the rest of the code. To handle these cases cleanly, we can use guard let statements to unwrap the optionals:

```
guard let listOne = list1 else { return list2 }
guard let listTwo = list2 else { return list1 }
```

Now that we have ensured that both `listOne` and `listTwo` have values, we can compare the values of the current nodes and proceed accordingly. If the value of `listOne` is greater than the value of `listTwo`, we know that `listOne` should come after `listTwo` in the merged list. In this case, we update the next node of `listTwo` using recursion by calling mergeTwoLists with `listOne` and the next node of `listTwo`. Then, we return `listTwo`.

```
if listOne.val > listTwo.val {
  listTwo.next = mergeTwoLists(listOne, listTwo.next)
  return listTwo
}
```

On the other hand, if the value of `listOne` is less than or equal to the value of `listTwo`, we know that `listTwo` should come after `listOne` in the merged list. In this case, we update the next node of `listOne` using recursion by calling mergeTwoLists with the next node of `listOne` and `listTwo`. Then, we return `listOne`.

```
if listOne.val > listTwo.val {
  listTwo.next = mergeTwoLists(listOne, listTwo.next)
  return listTwo
} else {
  listOne.next = mergeTwoLists(listOne.next, listTwo)
  return listOne
}
```

Since we are always passing in the next node of either `listOne` or `listTwo`, we *will* eventually come to an end, thus breaking our recursion loop.

This brings our final completed solution to:

```
func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
    guard let listOne = list1 else { return list2 }
    guard let listTwo = list2 else { return list1 }
    
    if listOne.val > listTwo.val {
      listTwo.next = mergeTwoLists(listOne, listTwo.next)
      return listTwo
    } else {
      listOne.next = mergeTwoLists(listOne.next, listTwo)
      return listOne
    }
}
```

With this recursive approach, we can successfully merge the two sorted linked lists and obtain the head of the merged list.
