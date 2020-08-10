---
date: 2020-07-27 22:03
description: The final part of building your own website using Swift. In here you will learn how to use the SplashPublishPlugin and deploy your website.
tags: Publish, Website
featuredDescription: Build your very own static website using, you guessed it, Swift!
---
# Build your very own website using Swift - Part 4

<div class="post-tags" markdown="1">
        <a class="post-category post-category-publish" href="/tags/publish">Publish</a>
        <a class="post-category post-category-website" href="/tags/website">Website</a>
        <a class="post-category post-category-verylongtagfortesting" href="/tags/website">Website</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-singl-left"><a href="/posts/01-build-a-website-with-publish-part-03" style="text-decoration: none">&larr; Pages, tags, and metadata</a></th>
    </tr>
</table>


### Using SplashPublishPlugin

Okay, let's be honest here. You are using Swift to make a website. If you've made it this far you are probably serious about starting some sort of blog. It's possible you're making a blog for recipes or traveling, but it's highly likely you're making one for programming. With programming, you probably plan to add some code. Go to your markdown file add add in the following code, but remove the space in between both sets of triple backticks.



```
`` `
func codeExample() -> String {
    return "Hello world!"
}
`` `
```


Yes, those backtick marks are necessary! That's how markdown knows you are adding code. View the post and you should see something like this.

<img class="post-image" src="/Images/Posts/01/01-13.png" alt="Xcode running publish" width="800"/>

There is no syntax highlighting! John Sundell has actually created a specific plugin that Publish can use to automatically apply this for us. Check out the [SplashPublishPlugin](https://github.com/JohnSundell/SplashPublishPlugin).
Let's go ahead and use this now, because you'll find that it's actually very easy to do!

The first thing we need to do is add the plugin as a dependency inside `Package.swift`. If you look at the file now you'll see this.

```
import PackageDescription

let package = Package(
    name: "BlogExample",
    products: [
        .executable(
            name: "BlogExample",
            targets: ["BlogExample"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "BlogExample",
            dependencies: ["Publish"]
        )
    ]
)
```
Edit it to look like this. We are just adding a new package and target dependency name.

```
import PackageDescription

let package = Package(
    name: "BlogExample",
    products: [
        .executable(
            name: "BlogExample",
            targets: ["BlogExample"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.6.0"),
        .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "BlogExample",
            dependencies: [
                "Publish",
                "SplashPublishPlugin"
            ]
        )
    ]
)
```
Sometimes I get some errors when doing this, if that happens close out Xcode and reopen it and it should fix itself and automatically install the new plugin. Then in your CSS file add the following

```
pre code {
    font-family: monospace;
    display: block;
    padding: 0 20px;
    color: #a9bcbc;
    line-height: 1.4em;
    font-size: 1.2em;
    overflow-x: auto;
    white-space: pre;
    border-radius: 10px;
    padding: 20px;
    -webkit-overflow-scrolling: touch;
}
pre code .keyword {
    color: #e73289;
}
pre code .type {
    color: #8281ca;
}
pre code .call {
    color: #348fe5;
}
pre code .property {
    color: #21ab9d;
}
pre code .number {
    color: #db6f57;
}
pre code .string {
    color: #fa641e;
}
pre code .comment {
    color: #6b8a94;
}
pre code .dotAccess {
    color: #92b300;
}
pre code .preprocessing {
    color: #b68a00;
}
```

We are almost done! We need to tell our program to actually use this plugin. Head over to `main.swift`  and add the following import statement at the top of the file.

```
import SplashPublishPlugin
```

Then at the bottom, edit the following function to include the plugin.

```
try BlogExample().publish(withTheme: .myTheme, plugins: [.splash(withClassPrefix: "")])
```

Congratulations! Run your website and you should see this

<img class="post-image" src="/Images/Posts/01/01-14.png" alt="Xcode running publish" width="800"/>

### Deploying your website online
Finally! You've made your website and you're ready to show the world. Github actually offers a way to host your website using [GitHub Pages](https://pages.github.com/). In order use this we need to do a few things.

First, initialize a new GitHub repository named `<your-username>.github.io`. For example, if your user name is `Swiftblogexample` your new repository will be named `Swiftblogexample.github.io`. Once you initialize it navigate to your terminal and clone your repo. To clone your repo type in the following command, replacing `Swiftblogexample` with your own. Then change into that directory and copy all your files from your website into it. Then open `package.swft` and let's make just a few more edits!

```
$ git clone https://github.com/Swiftblogexample/Swiftblogexample.github.io.git
$ cd Swiftblogexample.github.io
$ open package.swift
```

In `main.swift` add the deployment method for github, once again, replacing the url with your own.

```
try BlogExample().publish(
    withTheme: .myTheme,
    deployedUsing: .gitHub("Swiftblogexample/Swiftblogexample.github.io", useSSH: false),
    plugins: [.splash(withClassPrefix: "")]
)
```

Finally, while still in `main.swift` edit the url, name, description, and anything else you need to for your website.

```
// Update these properties to configure your website:
var url = URL(string: "www.swiftblogexample/swiftblogexample.github.io")!
var name = "BlogExample"
var description = "A description of BlogExample"
var language: Language { .english }
var imagePath: Path? { nil }
```

Then push the following changes to your repository and deploy using terminal.

```
$ git add .
$ git commit -m "commit for deployment"
$ git push
$ publish deploy
```

At this point, you'll see your terminal doing some work until you end up with a success message. Now navigate over `your-user-name.github.io` and you should see your live website! Here is the link to mine from this tutorial. [https://swiftblogexample.github.io](https://swiftblogexample.github.io). [Here](https://github.com/thomaskellough/BlogExample) is also a link to this repo so you can see everything in place.

I hope you've enjoyed this tutorial and I'd love to see what you come up with! You can find my contact information at the bottom.

<table class="posts-table">
    <tr>
        <th class="th-singl-left"><a href="/posts/01-build-a-website-with-publish-part-03" style="text-decoration: none">&larr; Pages, tags, and metadata</a></th>
    </tr>
</table>
