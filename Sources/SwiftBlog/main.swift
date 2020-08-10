import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct SwiftBlog: Website {
    
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case home
        case posts
        case tags
    }
    
    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        var featuredDescription: String?
        var readyToPublish: Bool?
    }
    
    // Update these properties to configure your website:
    var url = URL(string: "www.thomaskellough/thomaskellough.github.io")!
    var name = "The Swift Protocol"
    var description = "Swift Skill Building With Thomas Kellough"
    var language: Language { .english }
    var imagePath: Path? { nil }
    static var logoImagePath: Path { "/Images/blog-logo.png" }
    static let navItems = ["Home", "Posts", "Tags"]
}

extension Theme where Site == SwiftBlog {
    static var myTheme: Theme {
        Theme(htmlFactory: MyHtmlFactory(), resourcePaths: ["Resources/MyTheme/styles.css"])
    }
}


// This will generate your website using the built-in Foundation theme:
try SwiftBlog().publish(
    withTheme: .myTheme,
    deployedUsing: .gitHub("thomaskellough/thomaskellough.github.io", useSSH: false),
    plugins: [.splash(withClassPrefix: "")]
)

// Add to index.html
//<meta name="twitter:image" content="http://www.theswiftprotocol.com/images/social.png"/>
//<meta name="og:image" content="http://www.theswiftprotocol.com/images/social.png"/>
