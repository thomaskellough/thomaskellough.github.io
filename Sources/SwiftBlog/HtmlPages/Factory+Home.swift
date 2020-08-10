//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot

extension MyHtmlFactory {
    func makeHomeHTML(for index: Index, section: Section<SwiftBlog>, context: PublishingContext<SwiftBlog>) throws -> HTML {
        HTML(
            .head(for: index, on: context.site),
            .body(
                .myHeader(for: context),
                .div(
                    .explore(context: context)
                ),
                .div(
                    .featured(for: context.items(taggedWith: "Feature"), on: context.site)
                ),
                .myFooter(for: context.site)
            ) // body
        ) // html
    }
}
