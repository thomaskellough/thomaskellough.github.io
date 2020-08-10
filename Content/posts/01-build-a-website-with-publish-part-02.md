---
date: 2020-07-21 22:01
description: Part two of building your own website using Swift. This section focuses on creating custom nodes.
tags: Publish, Website, Extensions, Html, CSS
featuredDescription: Build your very own static website using, you guessed it, Swift!
---
# Build your very own website using Swift - Part 2

<div class="post-tags" markdown="1">
        <a class="post-category post-category-publish" href="/tags/publish">Publish</a>
        <a class="post-category post-category-website" href="/tags/website">Website</a>
        <a class="post-category post-category-extensions" href="/tags/extensions">Extensions</a>
        <a class="post-category post-category-html" href="/tags/html">Html</a>
        <a class="post-category post-category-css" href="/tags/css">CSS</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/01-build-a-website-with-publish-part-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/01-build-a-website-with-publish-part-03" style="text-decoration: none">Pages, tags, and metadata &rarr;</a></th>
    </tr>
</table>

### Creating your first blog page
This is a tutorial on how to make a blog, right? So let's create our first page that will list all of the blogs you plan to create. Remember, the goal of this tutorial is also to show you a way to keep your code organized. So what I'd recommend doing is creating a new directory under your `Sources/BlogExample` folder called `HtmlPages`. This is a good place to store the code for each section of your site such as home page, about me page, posts, contact information, or whatever you want really! After creating the directory create a new Swift file named `Factory+Posts.Swift` and write the following code.

```
import Publish
import Plot

extension MyHTMLFactory {
    func makePostsHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
         HTML(
            .head(for: context.index, on: context.site),
            .body(
                .text("Hello, posts!")
            )
        )
    }
}
```
Let's talk about what this does. This creates an extension for your custom HTMLFactory that allows you to create as many pages as you want and use in your website. You use an extension because we are adding it in a different Swift file for organization purposes. Technically, you could just add this function inside `MyHTMLFactory.swift` but it can be difficult to organize and find things later. Even though you don't need to write pure HTML, you do need to understand how it works. Publish actually takes your Swift code and then converts it to HTML. In every webpage you have your main HTML, a header that contains all the metadata your webpage holds, and then a body which contains all of your content. 

Press `cmd + R` to run your code then navigate over to `http://localhost:8000/posts/` to see your changes! You should now see "Hello, posts!" since that's what you typed for the body.

Let me guess, you saw "Hello, section" instead? Let's go over this. Navigate back over to to `MyHTMLFactory.swift` and take a look at the following function. 

```
func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
    HTML(.text("Hello, section"))
}
```
This is the function that is actually being called when you go to `http://localhost:8000/posts/`. So instead of returning that HTML, let's return the one you just created. Change the function to look like this.

```
func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
    try makePostsHTML(for: section, context: context)
}
```

Note that you need to mark it with a `try` because it can throw. Re-run your app, refresh your page and you should see this. If your page doesn't refresh try refreshing the cache using `cmd + option + e` if using safari, then reloading. This is a good command to remember when you're editing CSS. 

<img class="post-image" src="/Images/Posts/01/01-05.png" alt="Hello, posts! page" width="800"/>

We are getting somewhere! But I said the plan was to make a list of your posts. So head back over to `Factory+Posts.swift` and let's edit up the body of our function. Here's what we are going to do. 

1) Create an unordered list for each blog post

2) Loop over each blog post and create a list item for each one

3) Create a heading for our blog post and a link that allows us to click it and read the entire blog

4) Create a p tag (paragraph tag) that lists a description of what the post is about

This can get confusing, so I'll leave some comments to help explain for each step. Please, please watch your parentheses here. I highy suggest typing everything yourself and allowing Swift to autocomplete.

```
...
.body(
    // Create an unordered list
    .ul(
        // Loop over each blog post that we have in our code
        .forEach(
            section.items
        ) { item in
            // Creates a list item for each post
            .li (
                // Creates an article node to display our information
                .article(
                    // Creates a heading with our post title
                    .h1(
                        // Creates an anchor tag so we can create the link to our post
                        .a(
                            // Creates the link to our post so we can click it and read everything
                            .href(item.path),
                            .text(item.title)
                        )
                    ),
                    // Creates a description  of what our post is about
                    .p(.text(item.description))
                )
            )
        }
    )
)
...
```
Wow, that's a lot. But re-run your app and you should see this! You can even click the link and see a new page!

<img class="post-image" src="/Images/Posts/01/01-06.png" alt="Xcode running publish" width="800"/>

Now I know what you're thinking. You never wrote that blog post and where did it come from? Navigate over to your Project Navigator and look under `Content/posts/first-post.md`. Open that up and take a look. Here's what you should see.
```
---
date: 2020-07-30 21:47
description: A description of my first post.
tags: first, article
---
# My first post

My first post's text.
```
This is a markdown file and this is how you will write all of your blog posts. I won't be doing a markdown tutorial here, but it's easy enough to Google when you want to figure out what to do. The important thing here is how the beginning is organized. You'll notice that you used `item.title` and `item.description` in the above function. The description is on the third line of your markdown file while the title is on the sixth line. We will discuss this in detail later. For now, create a new file in the same `posts` directory and give it some dummy content, or copy mine. Make sure it's the same formatting and don't forget to remove the swift extension.

```
---
date: 2020-07-30 21:47
description: A description of my second post.
tags: second, article
---
# My second post

My second post's text.
```
Re-run your code, refresh your browser and you should now see TWO posts. The cool thing about Publish is once you get your site up and running, you only need to edit your markdown files to add new posts! However, let's make it look a bit better because right now it's not fun to read. This is done with one single line of code since there is a lot of CSS that was already created. Above your `.forEach` loop add a class. Feel free to dig through your CSS code to see what each class does! Your change should look like this.

```
...
.ul(
    // Loop over each blog post that we have in our code
    .class("item-list"),
    .forEach(
        section.items
    ) { item in
...
```
This should now format your posts to look a bit better. Now we need to add a header and a footer, but as you can see, this is going to get very messy and unorganized with all the parentheses inside your html body. So how can we fix this? 
Well the way Publish works is by creating nodes for all the HTML elements. We aren't going to dig deep into nodes with Swift, but I want you to understand that each time you create a body, or h1 tag, or p tag, or article, button, or anything else with HTML a node is created. They are highly reusable and easy to break apart and combine together. So what we want to do is create a specific node that is *only* for the post content. 

Similar to how we create a new directory for HtmlPages, let's create another new directory called `Nodes` under `Sources/BlogExample` then create a new swift file called `Node+PostsContent` inside the new directory. I want you to add the following code.
```
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func postContent<T: Website>(for items: [Item<T>], on site: T) -> Node {
    
    }
}
```
Let's discuss this. Here you create an extension on Node for HTML content inside of your body. The function is set up as a generic (that's what the T is all about) which allows us to pass in data type we want. The function also returns a Node. This is the important part. You can put as much code in here which returns one node, which we can then use in our html pages. Why would we do this? It helps keep everything organized and separated. It's using functional programming for better architecture. So the next part is going back to your `Factory+Posts.swift` file and removing everything from the body and placing it inside this new function. Then you can call your `.postContent` function inside `Factory+Posts.swift` and pass in both your items and site. To get `[Item<T>]` you just call `section.items` and to get `site` you just call `context.site`. Notice that we also made this function static. This allows us to use it anywhere. 

There is one more thing I want to add while we are back in postContent. Let's add a way to sort our posts by date and also list the date published on each post. We will do this by: 

1) Creating a date formatter from Swift's foundation library

2) Call Swift's built-in sorted method to create a new list sorted by date

3) Loop over the newly created list in our forEach loop instead of the one passed in

4) Add a paragraph tag displaying the formatted date on each post

When you're finished, your two new extensions should look like this. We did have to change `section.items` to `items` in line 20 of `postContent`. This is because our function now uses a parameter of items instead of section so we can just call items directly.

```
extension MyHTMLFactory {
    func makePostsHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
         HTML(
            .head(for: context.index, on: context.site),
            .body(
                .postContent(for: section.items, on: context.site)
            )
        )
    }
}

...
import Foundation

extension Node where Context == HTML.BodyContext {
    static func postContent<T: Website>(for items: [Item<T>], on site: T) -> Node {
    
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let sortedItems = items.sorted {
            $0.date < $1.date
        }
        
        return
            // Create an unordered list
            .ul(
                // Loop over each blog post that we have in our code
                .class("item-list"),
                .forEach(
                    sortedItems
                ) { item in
                    // Creates a list item for each post
                    .li (
                        // Creates an article node to display our information
                        .article(
                            // Creates a heading with our post title
                            
                            .h1(
                                // Creates an anchor tag so we can create the link to our post
                                .a(
                                    // Creates the link to our post so we can click it and read everything
                                    .href(item.path),
                                    .text(item.title)
                                )
                            ),
                            // Creates a description  of what our post is about
                            .p(.text(item.description)),
                            .p(.text("Published: \(formatter.string(from: item.lastModified))"))
                        )
                    )
                }
        )
    }
}
```
Run your code and it should look the same! The rest of this tutorial should go by rather quickly. We have most of the difficult part out of the way. You know how to install and launch your website, create new html pages, and create new nodes. Let's start adding a few things to make it look better and then discuss how to add new pages and tags. 

### Adding a wrapper node
Publish comes with a CSS wrapper class that we can help make our content look better. Let's first create this node so we can use it anywhere in our website. Go ahead and create a new swift file called `Node+Wrapper.swift` and add the following code.

```
import Publish
import Plot


extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }
}
```

Then wrap everything inside your post content inside the .wrapper(). Your return statement should look like this.

```
return
    .wrapper(
        // Create an unordered list
        .ul(
            // Loop over each blog post that we have in our code
            .class("item-list"),
            .forEach(
                sortedItems
            ) { item in
                // Creates a list item for each post
                .li (
                    // Creates an article node to display our information
                    .article(
                        // Creates a heading with our post title
                        
                        .h1(
                            // Creates an anchor tag so we can create the link to our post
                            .a(
                                // Creates the link to our post so we can click it and read everything
                                .href(item.path),
                                .text(item.title)
                            )
                        ),
                        // Creates a description  of what our post is about
                        .p(.text(item.description)),
                        .p(.text("Published: \(formatter.string(from: item.lastModified))"))
                    )
                )
            }
        )
)
```
You should be able to run your code now and see your posts look a bit nicer. Here's an example of what you should see.

<img class="post-image" src="/Images/Posts/01/01-07.png" alt="Wrapper example on posts" width="800"/>

### Adding a header
Now let's add a header that we can display on every webpage. We will do this by creating a colored banner with a simple title along with some navigation buttons. This next node extension will accomplish the following tasks.

1) It will create a list of navigation items for the different pages of your website

2) It will return a header node wrapped around a wrapper node

3) Inside the wrapper node you'll create a header for your title

4) Below the title you'll create a .nav node that contains an unordered list of your navigation items

5) Each navigation item will link you to that specific web page. For example, if you click "Home" you will be redirected to `http://localhost:8000/home`

Start by creating a new file called `Node+Header.swift` and add the following code. I've also added comments to help explain what each piece is.

```
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    
    static func myHeader<T: Website>(for context: PublishingContext<T>) -> Node {
        // Create a list of navigation items
        let navItems = ["Home", "Posts", "About"]
        
        return .header(
            // Begin the wrapper class
            .wrapper(
                // Create your main title
                .h1("My Swift Blog"),
                // Create the nav node
                .nav(
                    // Create and undordered list and loop through your navItems yuou created above
                    .ul(
                        .forEach(
                            navItems
                        ) { item in
                            .li(
                                // Create an anchor tag to make linkes
                                .a(
                                    // Redirect the user to a new webpage on your site when they click each item
                                    .href("/\(item.lowercased())"),
                                    .text(item)
                                )
                            )
                        }
                    )
                )
            )
        )
    }
}
```

You have now created the node, but you naven't actually used it on one of your pages yet. Go back to `Factory+Posts.swift` and add in your .myHeader function. It should now look like this. You can already see how separating nodes will help keep your html pages oraganized.

```
extension MyHTMLFactory {
    func makePostsHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
         HTML(
            .head(for: context.index, on: context.site),
            .body(
                .myHeader(for: context),
                .postContent(for: section.items, on: context.site)
            )
        )
    }
}
```

You can run this now and see it in action, but before you do, I suggest we add our own custom color to the banner up top. We will do this by also creating a gradient background instead of just a solid color. There is already a header class in our CSS file, so jump in there and look for 

```
header {
    background-color: #eee;
}
```

Change it to look like this

```
header {
    background: linear-gradient(90deg, rgba(2,0,36,1) 2%, rgba(9,9,121,1) 29%, rgba(0,212,255,1) 100%);
}
```

Feel free to play with it as you see fit. But if you did the above you should have something that looks like this now.

<img class="post-image" src="/Images/Posts/01/01-08.png" alt="Header example" width="800"/>

### Add a footer
Go ahead and create a new node called `Node+Footer.swift` and let's do the following. 

1) Create a variable that automatically gets the current year

2) Create a container that contains the copyright symbol with the year and the name of your site

3) Create a link to John Sundell's Publish repo to show people how you generated this website 

Note that we will need to add the Foundation library in order to get our current calendar date.
Add in the following code.

```
import Foundation
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func myFooter<T: Website>(for site: T) -> Node {
        // Creates a variable to get the current year of today
        let currentYear = Calendar.current.component(.year, from: Date())
        
        return
            // Creates a container
            .div(
                // Provides a CSS class to this container
                .class("footer"),
                // Creates another container for copyright information
                .div(
                    .text("© \(currentYear) \(site.name)")
                ),
                // Creates another container for link to John Sundell's publish repo
                .div(
                    .text("Generated using "),
                    .a(
                        .text("Publish"),
                        .href("https://github.com/johnsundell/publish")
                    ),
                    .text(". Written in Swift")
                )
        )
    }
}
```
Add your footer inside `Factory+Posts.swift`, but note that the parameter is different for the footer than it is the header. The parameter used for the header is a `context` while the footer's parameter is `Website`. Feel free to change these as you see fit, but if you wrote it the same way I did, your `Factory+Posts` will now look like this.

```
extension MyHTMLFactory {
    func makePostsHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
         HTML(
            .head(for: context.index, on: context.site),
            .body(
                .myHeader(for: context),
                .postContent(for: section.items, on: context.site),
                .myFooter(for: context.site)
            )
        )
    }
}
```
<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/01-build-a-website-with-publish-part-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/01-build-a-website-with-publish-part-03" style="text-decoration: none">Pages, tags, and metadata &rarr;</a></th>
    </tr>
</table>
