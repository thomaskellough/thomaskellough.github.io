//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot

extension MyHtmlFactory {
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<SwiftBlog>) throws -> HTML? {
        HTML(
            .head(for: context.index, on: context.site),
            .body(
                .myHeader(for: context),
                .h1(
                    .text("All posts with the tag \(page.tag.string)")
                ),
                .postContent(for: context.items(taggedWith: page.tag), on: context.site)
            ) // body
        )
    }
}
