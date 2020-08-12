//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot

extension MyHtmlFactory {
    func makeAboutHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .myHead(for: context.index, on: context.site),
            .body(
                .myHeader(for: context),
                .wrapper(
                    .ul(
                        .class("item-list"),
                        .li(.text("Hello world")),
                        .li(.text("Another item")),
                        .li(.text("AND A THIRD!"))
                    ) // ul
                ), // wrapper
                .myFooter(for: context.site)
            ) // body
        ) // html
    }
}
