---
date: 2020-07-24 22:02
description: Part three of building your own website using Swift. This section focuses on adding new pages to your website, tags, and metadata.
tags: Publish, Website, Enums
featuredDescription: Build your very own static website using, you guessed it, Swift!
---
# Build your very own website using Swift - Part 3

<div class="post-tags" markdown="1">
        <a class="post-category post-category-publish" href="/tags/publish">Publish</a>
        <a class="post-category post-category-website" href="/tags/website">Website</a>
        <a class="post-category post-category-enums" href="/tags/enums">Enums</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/01-build-a-website-with-publish-part-02" style="text-decoration: none">&larr; Creating your own nodes</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/01-build-a-website-with-publish-part-04" style="text-decoration: none">SplashPlugin and deployment &rarr;</a></th>
    </tr>
</table>

### Adding new pages
If you haven't noticed already, you created a nav bar with links to other pages, but they don't work yet! And how does your website already have a working link for `http://localhost:8000/posts/`? We never actually specifically defined this anywhere during this tutorial.  The reason for that is simple, it was already done for you. In fact, you have probably already seen it if you looked at your `main.swift` file. Go there and check out this code.

```
enum SectionID: String, WebsiteSectionID {
    // Add the sections that you want your website to contain here:
    case posts
}
```

Each enum case holds a different section of your website, or the following url from your main webpage. In our nav bar, we created three buttons, home, posts, and about. Let's add two more cases so it matches those.

```
enum SectionID: String, WebsiteSectionID {
    // Add the sections that you want your website to contain here:
    case home
    case posts
    case about
}
```
This tells Publish that our website has a section with these titles, however, at this point Publish still doesn't know what to display for each section. Navigate back over to `MyHTMLFactory.swift` and look for the following code.

```
func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
    try makePostsHTML(for: section, context: context)
}
```
This is part of the HTMLFactory protocol that we **need** to have. Notice that it returns an HTML struct, just like your `Factory+Posts.swift` does. In fact, if you wanted, you could create an extension for makeSectionHTML and put it with your HtmlPages folder, but I'll leave that part up to you. What I want to do now is show you how to use tell Publish which HTML page to render based off which enum case you added in SectionID. All it takes is a simple switch statement telling it to render a different page. Edit your makeSectionHTML to look like this.

```
func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
    switch section.id.rawValue {
    case "posts":
        return try makePostsHTML(for: section, context: context)
    case "home":
    return HTML(.text("Hello home!"))
    case "about":
        return HTML(.text("Hello about!"))
    default:
        return try makePostsHTML(for: section, context: context)
    }
}
```
If we want to get what we typed inside of our SectionIDs, we can just call `section.id.rawValue`  to get the string of each case. Then depending on what it says you return a different HTML. Note that we had to add in the `return` keyword this time. This is because as of Swift 5.1 you're allowed to omit the `return` keyword if you have a single expression. However, with the switch statement, we have multiple expressions. For the default, I left it as returning the posts content page, but feel free to edit that as you see fit.

You should now be able to click on the navigation items and see your new content, however, it's not that exciting because we haven't actually rendered anything other than a simple two lines of text. Let's go ahead and create a simple home page now. It won't be exciting, but I at least want to show you how to add images to your website.

### Creating a home page
Create a new file called `Factory+Home.swift`, and add in the following code.  This is nothing new, it's just rendering a new html and adding your header and footer.

```
import Publish
import Plot

extension MyHTMLFactory {
    func makeHomeHTML<T: Website>(for index: Index, section: Section<T>, context: PublishingContext<T>) throws -> HTML {
        HTML(
            .head(for: index, on: context.site),
            .body(
                .myHeader(for: context),
                .myFooter(for: context.site)
            )
        )
    }
}
```
Then navigate back to makeSectionHTML and edit your case for "home" to look like this

```
case "home":
    return try makeHomeHTML(for: context.index, section: section, context: context)
```

You should now be able to reload and see your home page with your header and footer showing. But let's add an image at the top. Pick any image you want but I'll be using the following.

<img class="post-image" src="/Images/Posts/01/01-09.png" alt="Swift logo" width="800"/>

The first step is adding our image to our project. Inside your project navigator, under the Resources folder create a new folder called Images and drag and drop an image of your choosing in there. Here's what it should look like when you are finished

<img class="post-image" src="/Images/Posts/01/01-10.png" alt="Xcode running publish" width="800"/>

In order to add images in Publish we use a .img class="post-image" node which takes a .src(Path) as a parameter. So we need to create a variable that gets the path to your image, then pass that inside our .img class="post-image" node. Let's also give the .img class="post-image" a class so we can edit it if we need to. Back in `Factory+Home.swift` edit your function to look like this. Note that we also had to add in the `return` keyword now since we don't have a single expression anymore.

```
extension MyHTMLFactory {
    func makeHomeHTML<T: Website>(for index: Index, section: Section<T>, context: PublishingContext<T>) throws -> HTML {
        var homeImage: Path { "Images/swift-logo.png" }
        
        return
            HTML(
                .head(for: index, on: context.site),
                .body(
                    .myHeader(for: context),
                    .class("logo-image"),
                    .img class="post-image"(.src(homeImage)),
                    .myFooter(for: context.site)
                )
        )
    }
}
```
For me, I wanted to make my image a bit smaller so I added this to my CSS file.

```
.logo-image img class="post-image" {
    width: 30%;
    margin: 20px;
}
```

Here's what your website should look like now.

<img class="post-image" src="/Images/Posts/01/01-11.png" alt="Home page with logo" width="800"/>

Great job! You now have a home page! I'll let you go ahead and make your own about me page using the same technique. Remember, you need to create a new `Factory+About.swift` file and add in your returning HTML. Then you need to go back to `MyHTMLFactory.swift` and edit your makeSectionHTML function to handle the case of "about".

### Organizing sections easier
This is a small piece, but what I want to show you is a neat little Swift trick. In programming, you really don't want to repeat yourself. However, you'll see that when you create your sections, you also have to create your list of nav items inside your header. Let's fix that. Go to your SectionID enum and make it conform to CaseIterable. It should look like this.

```
enum SectionID: String, WebsiteSectionID, CaseIterable {
    // Add the sections that you want your website to contain here:
    case home
    case posts
    case about
}
```

Then, go back to your `Node+Header.swift` and let's edit a few things.

1) We will first delete our list that we created.

2) Then we will loop over our enum cases by using `BlogExample.SectionID.allCases`.

3) Then for our text, we will get the raw value of each enum case and call the capitalized method on it so each word has a capital first letter.

Here's what it should look like when you finish. Now you can add new sections without having to edit your header file!

```
static func myHeader<T: Website>(for context: PublishingContext<T>) -> Node {
    // Create a list of navigation items
    
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
                        BlogExample.SectionID.allCases
                    ) { item in
                        .li(
                            // Create an anchor tag to make linkes
                            .a(
                                // Redirect the user to a new webpage on your site when they click each item
                                .href("/\(item.rawValue.lowercased())"),
                                .text(item.rawValue.capitalized)
                            )
                        )
                    }
                )
            )
        )
    )
}
```

### Tags
We are almost done here, but there's a couple of things left to show you. The next thing on my list is showing you how to add tags to your post. Navigate to one of your markdown files and look towards the top you'll see something like this.

```
---
date: 2020-07-30 21:47
description: A description of my first post.
tags: first, article
---
```

You can add as many tags as you want, so have fun with it. Let's create a new file called `Node+Tags.swift`. We are going to do a few things here.

1) Create a function that returns a list of tags

2) The function accepts two parameters, one is a list of tags while the other is which website you're editing

3) We will loop over each tag and provide two CSS classes. One class for it being a tag, and another class for it being a *specific* tag so we can edit them differently, such as background color

4) Create a link that when you click on the tag, only posts that have that tag will show up

Add the following code to `Node+Tags.swift`.

```
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    
    static func tagList<T: Website>(for tags: [Tag], on site: T) -> Node {
        return
            .div(
                .forEach(tags) { tag in
                    .a(
                        .class("post-category post-category-\(tag.string.lowercased())"),
                        .href(site.path(for: tag)),
                        .text(tag.string)
                    )
                })
    }
}
```
Then in `Node+PostsContent.swift` we need to actually call this function. Edit your file to include your new function. For your parameter, you can get every tag on each item by calling `item.tags`.

```
...
// Creates a description  of what our post is about
.tagList(for: item.tags, on: site),
.p(.text(item.description)),
...
```
Now before you run it, let's add those CSS classes so they look a bit interesting. Go to your CSS file and add the following code.

```
.post-category {
    margin: 1px;
    padding: 0.3em 1em;
    color: #fff;
    background: #999;
    font-size: 60%;
    border-radius: 8px;
    text-decoration: none;
}

.post-category-first {
    background-color: green;
}

.post-category-second {
    background-color: purple;
}

.post-category-article {
    background-color: darkred;
}
```

Run your program, refresh the cache if necessary (cmd + option + e for Safari), and you should see something like this.

<img class="post-image" src="/Images/Posts/01/01-12.png" alt="Posts with tags" width="800"/>

### Adding a tag details page
Now you'll notice that if you click on the tags it takes you to a new page, but hasn't filtered your posts. But you will notice that it says "Hello, tag details". Let's go back to `MyHTMLFactory.swift` and look for this function.

```
func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
    HTML(.text("Hello, tag details"))
}
```

Now this next part is your call. Either create a new `Factory+TagDetails.swift` file and move this function in there, or edit it directly in MyHTMLFactory.swift. Either is fine. Whichever you choose, we need to edit this function to show us our tags. We will do the following things.

1) Create a returning HTML() that returns a head like every other HTML() file we have

2) Add the header and footer that you created earlier to the body

3) Add a .postContent node, but with a specific parameter that automatically filters out our tags for us. Note that you do NOT need to add new case statements in your SectionID enum since it will automatically be generated for you with each tag!

Edit your function to look like this.

```
func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
    HTML(
        .head(for: context.index, on: context.site),
        .body(
            .myHeader(for: context),
            .h1(
                .text("All posts with the tag \(page.tag.string)")
            ),
            .postContent(for: context.items(taggedWith: page.tag), on: context.site),
            .myFooter(for: context.site)
        )
    )
}
```

Run your code, refresh your website, click on the actual tag itself and you should see your posts automatically filter. Woo-hoo!

### Adding post content
I know it seems weird that we can't actually view our posts yet. I'm sure you've clicked on it only to see "Hello item". At this point I suggest you try to figure out how to fix that on your own. You may be able to do it ;).

Still here? I'll show you how this works. You'll notice in `MyHTMLFactory.swift` we have the following function.

```
func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
    HTML(.text("Hello, item"))
}
```

All we need to do is return the description of our item in order to see the post. Remember how there are markdown files? The great thing about that is if you format it in the markdown file, you don't need to format it here! Edit your makeItemHTML to look like this.

```
func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
    HTML(
        .head(for: item, on: context.site),
        .body(
            .myHeader(for: context),
            .wrapper(
                .article(
                    .contentBody(item.body)
                )
            ),
            .myFooter(for: context.site)
        )
    )
}
```
You should now be able to click and view your posts! And honestly, we are nearly done! There are a couple of things left we need to do before we actually publish our website. The next item we want to look at is adding metadata.

### Adding metadata
Publish comes with a lot of things to help you organize your website and filter posts, but what if we wanted more? We can actually achieve this using metadata. Head over to `main.swift` and look for the following function.

```
struct ItemMetadata: WebsiteItemMetadata {
    // Add any site-specific metadata that you want to use here.
}
```
Let's say you have multiple different authors working on posts for your blog. Add the following variable.

```
struct ItemMetadata: WebsiteItemMetadata {
    // Add any site-specific metadata that you want to use here.
    var author: String?
}
```

Let's add some authors to our blog posts. Edit your markdown files to look like this, but give each post a different author.

**Note, my posts include Harry Potter spoilers!**

```
---
date: 2020-08-02 10:57
description: Dumbledore speaking about Cedric's death.
tags: first, article
author: Albus Dumbledore
---
# Dumbledore - Speech about Cedric Diggory

The Ministry of Magic does not wish me to tell you this. It is possible that some of your parents will be horrified that I have done so – either because they will not believe that Lord Voldemort has returned, or because they think I should not tell you so, young as you are. It is my belief, however, that the truth is generally preferable to lies, and that any attempt to pretend that Cedric died as the result of an accident, or some sort of blunder of his own, is an insult to his memory.
```

```
---
date: 2020-07-30 21:47
description: Hermione speaking to Harry about Cho's feelings.
tags: second, article
author: Hermione Granger
---
# Hermione Granger - To Harry about Cho Chang

Well, obviously, she\'s feeling very sad, because of Cedric dying. Then I expect she's feeling confused because she liked Cedric and now she likes Harry, and she can't work out who she likes best. Then she'll be feeling guilty, thinking it's an insult to Cedric's memory to be kissing Harry at all, and she'll be worrying about what everyone else might say about her if she starts going out with Harry. And she probably can't work out what her feelings towards Harry are anyway, because he was the one who was with Cedric when Cedric died, so that's all very mixed up and painful. Oh, and she's afraid she's going to be thrown off the Ravenclaw Quidditch team because she's flying so badly.

```

Then create a new swift file called `Node+Author.swift` and add in the following code.

```
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    
    static func postsBy(author: String, section: Section<BlogExample>, on site: BlogExample) -> Node {
        
        let items = section.items.filter {
            $0.metadata.author == author
        }
        
        return
            .wrapper(
                .div(
                    .h1("Posts by \(author)"),
                    .postContent(for: items, on: site)
                )
        )
    }
    
}
```
This will take in a specific string, filter out all items from a section by matching up the metadata to the string passed in, then return a wrapper that contains the new filtered list while also creating a heading separating the posts. Head back over to `Factory.Posts.swift` and change your function to look like this.

```
extension MyHTMLFactory {
    func makePostsHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
         HTML(
            .head(for: context.index, on: context.site),
            .body(
                .myHeader(for: context),
                .postsBy(author: "Albus Dumbledore", section: section, on: context.site),
                .postsBy(author: "Hermione Granger", section: section, on: context.site),
                .myFooter(for: context.site)
            )
        )
    }
}
```
You'll see that we no longer call postsContent, because our new postsBy method automatically calls that for us. There is one other issue here. Trying to access this metadata gives us trouble when using generics. Maybe John Sundell knows a better way to handle this, but I've found that removing the generic portion and actually using our website inside MyHTMLFactory can solve this issue. Go back to `MyHTMLFactory.swift` and change every instance of `Site` to `BlogExample` and remove the `<T: Website>`. It should look like this when you are finished.

```
struct MyHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<BlogExample>) throws -> HTML {
        HTML(.text("Hello, index"))
    }

    func makeSectionHTML(for section: Section<BlogExample>, context: PublishingContext<BlogExample>) throws -> HTML {
        switch section.id.rawValue {
        case "posts":
            return try makePostsHTML(for: section, context: context)
        case "home":
            return try makeHomeHTML(for: context.index, section: section, context: context)
        case "about":
            return HTML(.text("Hello about!"))
        default:
            return try makePostsHTML(for: section, context: context)
        }
    }

    func makeItemHTML(for item: Item<BlogExample>, context: PublishingContext<BlogExample>) throws -> HTML {
        HTML(
            .head(for: item, on: context.site),
            .body(
                .myHeader(for: context),
                .wrapper(
                    .article(
                        .contentBody(item.body)
                    )
                ),
                .myFooter(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page, context: PublishingContext<BlogExample>) throws -> HTML {
        HTML(.text("Hello, page"))
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<BlogExample>) throws -> HTML? {
        HTML(.text("Hello, tag list"))
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<BlogExample>) throws -> HTML? {
        HTML(
            .head(for: context.index, on: context.site),
            .body(
                .myHeader(for: context),
                .h1(
                    .text("All posts with the tag \(page.tag.string)")
                ),
                .postContent(for: context.items(taggedWith: page.tag), on: context.site),
                .myFooter(for: context.site)
            )
        )
    }
}

```
Now refresh your webpage and you'll see that your posts are separated by author.

### Redirecting the index
A website's index page is the initial page that automatically loads when you first go to a website. What we are going to do here is redirect our index page to go to our home page. This way whenever you go to www.yourblog.com it automatically takes you to your home page. To achieve this we need to do a few things.

1) Create a constant for all sections of the current context

2) Get the first section from the constant created in step 1 where the enum case equals "home"

3) Call your makeHomeHTML function and pass in the proper parameters

Go back to `MyHTMLFactory.swift` and edit your makdeIndexHTML to look like this

```
func makeIndexHTML(for index: Index, context: PublishingContext<BlogExample>) throws -> HTML {
    let sections = context.sections
    let section = sections.first(where: { $0.id.rawValue == "home" })!
    
    return try makeHomeHTML(for: index, section: section, context: context)
}
```
<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/01-build-a-website-with-publish-part-02" style="text-decoration: none">&larr; Creating your own nodes</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/01-build-a-website-with-publish-part-04" style="text-decoration: none">SplashPlugin and deployment &rarr;</a></th>
    </tr>
</table>
