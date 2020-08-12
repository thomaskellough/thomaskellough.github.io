//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot

extension MyHtmlFactory {
    func makePostsHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
         HTML(
            .myHead(for: context.index, on: context.site),
            .body(
                .myHeader(for: context),
                .postContent(for: section.items, on: context.site),
                .myFooter(for: context.site)
            ) // body
        )
    }
}
