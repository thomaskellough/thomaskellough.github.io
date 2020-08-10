//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot

extension MyHtmlFactory {
    func makeTagsHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        
        let tags = context.allTags.filter {
            $0.string != "Feature"
        }
        
        return HTML(
            .head(for: context.index, on: context.site),
            .body(
                .myHeader(for: context),
                .h1(.text("Search through contents by tags")),
                .tagList(for: tags, on: context.site),
                .myFooter(for: context.site)
            ) // body
        ) // html
    }
}
