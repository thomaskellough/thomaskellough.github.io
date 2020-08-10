//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/26/20.
//

import Foundation
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    
    static func explore(context: PublishingContext<SwiftBlog>) -> Node {
//        let randomTags = context.allTags.prefix(5)
        let randomTags = context.allTags
        
        return .wrapper(
            .div(
                .class("title-icon"),
                .div(
                    .class("item-list title title-explore"),
                    .img(.src(Image.Icon.explore)),
                    .h1(.text("Explore topics"))
                ),
                .tagList(for: Array(randomTags), on: context.site),
                .h4(
                    .a(
                        .href("/tags"),
                        .text("Or click here to see all tags!")
                    ) // a
                )
            )
        ) // wrapper
    }
}
//.div(
//    .class("title"),
//    .img(.src(Image.Icon.featured)),
//    .h1(.text("Featured posts"))
//),
