//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func tagList<T: Website>(for tags: [Tag], on site: T) -> Node {
        return .div(
            .class("post-tags"),
            .forEach(tags) { tag in
                .a(
                    .class("post-category post-category-\(tag.string.lowercased())"),
                    .href(site.path(for: tag)),
                    .text(tag.string)
                )
            })
    }
    
    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .tagList(for: item.tags, on: site)
        
    }
    
    static func tagList<T: Website>(for page: TagListPage, on site: T) -> Node {
        return .tagList(for: Array(page.tags), on: site)
    }
    
    static func tagList<T: Website>(for tags: Set<Tag>, on site: T) -> Node {
        
        let orderedTags = Array(tags).sorted()
        
        return .wrapper(
            .div(
                .class("post-tags post-tags-shaded"),
                .forEach(orderedTags) { tag in
                    .a(
                        .class("post-lg post-category post-category-\(tag.string.lowercased())"),
                        .href(site.path(for: tag)),
                        .text(tag.string)
                    )
                })
        )
    }
}
