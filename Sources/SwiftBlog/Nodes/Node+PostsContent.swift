//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Foundation
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    
    static func postContent(for items: [Item<SwiftBlog>], on site: SwiftBlog) -> Node {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        
        
        let sortedItems = items.sorted {
            $1.date < $0.date
        }.filter {
            $0.metadata.readyToPublish != false
        }
        
        return .wrapper(
            .ul(
                .class("item-list"),
                .forEach(
                    sortedItems
                ) { item in
                    .li(
                        .article(
                            .h1(
                                .a(
                                    .href(item.path),
                                    .text(item.title)
                                ) // a
                            ),
                            .tagList(for: item, on: site),
                            .p(.text(item.description)),
                            .p(.text("Published: \(formatter.string(from: item.date))"))
                        ) // article
                    ) // li
                } // forEach
            ) // ul
        ) // wrapper
    }
}
