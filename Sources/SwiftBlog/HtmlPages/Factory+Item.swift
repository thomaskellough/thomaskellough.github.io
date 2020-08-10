//
//  File.swift
//
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot

extension MyHtmlFactory {
    func makeItemHTML(for item: Item<SwiftBlog>, context: PublishingContext<SwiftBlog>) throws -> HTML {
        HTML(
            .head(for: item, on: context.site),
            .body(
                .myHeader(for: context),
                .wrapper(
                    .article(
                        .contentBody(item.body)
                    ) // article
                ), // wrapper
                .myFooter(for: context.site)
            ) // body
        ) // html
    }
}
