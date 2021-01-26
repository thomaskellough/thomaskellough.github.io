---
date: 2021-01-24 12:09
description: This section wraps everything up as well as gives you some ideas on how you can improve your app.
tags:
---
# Create a unique Valentine's Day app for your loved one - Part 5

<div class="post-tags" markdown="1">
  <a class="post-category post-category-labeledstatements" href="/tags/labeledstatements">LabeledStatements</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/13-x-things-i-love-about-you-part-04" style="text-decoration: none">&larr; Adding local notifications</a></th>
    </tr>
</table>

### Conclusion
And there you have it. A personalized app that you can give to someone. Of course, you won't be able to put this on the app store (you could try TestFlight, but I can't guarantee that it will get approved). The easiest way is to just borrow their phone and install it directly from Xcode.

This is an app you can do all kinds of things with and I encourage you to add to it. Here are some suggestions:

1) Go back to [https://iosexample.com/](https://iosexample.com/) and see what other cool features you want to add. There are some good label packages that can make your text different colors and flash that may be fun to try.

2) Add more animations! I gave you two, but it's so easy to add more then adjust your random animation function. Try doing a slide-from-(left/right/top/bottom), big-to-small, or if you're feeling crazy, a nice spin animation! Remember, once you write them you can easily use them in the rest of your projects.

3) If you haven't noticed, there are a few things that could be improved and written better. One thing that that comes to mind is hardcoding the UserDefault strings. See if you can figure out a way to create a variable to use across all classes. You can make static variables, create custom structs, or create some type of extension. It's really up to you.

4) You may want to also clean up your view controller and separate your table view into multiple files. If you're interested in that and don't know I have an article on that [here](https://theswiftprotocol.com/posts/11-how-to-seprate-tableview-views-and-datasource/).

5) Something you really should do is add an app icon. I used one of the images I used in my compliments, but feel free to get creative with it.

6) Build on this app to create something entirely different. Maybe you have a kid that likes to read at night, but you don't want them staying up super late. Many avid readers know how easy it is to get sucked into a good story. You could create a story and release a "chapter" a night. This can help promote reading while also keeping a healthy sleep schedule.

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/13-x-things-i-love-about-you-part-04" style="text-decoration: none">&larr; Adding local notifications</a></th>
    </tr>
</table>
