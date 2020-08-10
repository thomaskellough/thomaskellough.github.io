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
    
    static func featured(for items: [Item<SwiftBlog>], on site: SwiftBlog) -> Node {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let sortedItems = items.sorted {
            $0.date < $1.date
        }
        
        assert(sortedItems.compactMap {
            $0.metadata.featuredDescription
        }.count == sortedItems.count,
               "Error! Could not find feature descriptions!"
        )
        
        return .wrapper(
            .div(
                .class("title-icon"),
                .div(
                    .class("title title-featured"),
                    .img(.src(Image.Icon.featured)),
                    .h1(.text("Featured posts"))
                )
            ),
            .div(
                .class("grid"),
                .ul(
                    .class("item-list grid"),
                    .forEach(
                        sortedItems
                    ) { item in
                        .li(
                            .article(
                                .h2(
                                    .a(
                                        .href(item.path),
                                        .text(item.title.replacingOccurrences(of: " - Part 1", with: ""))
                                    ) // a
                                ),
                                .tagList(for: item, on: site),
                                .p(.text(item.metadata.featuredDescription ?? ""))
                            ) // article
                        ) // li
                    } // forEach
                ) // ul
            )
        ) // wrapper
    }
}
