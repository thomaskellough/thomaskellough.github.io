//
//  File.swift
//
//
//  Created by Thomas Kellough on 7/23/20.
//

import Foundation
import Publish
import Plot

struct MyHtmlFactory: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<SwiftBlog>) throws -> HTML {
        let sections = context.sections
        let section = sections.first(where: { $0.id.rawValue == "home" })!
        
        return try makeHomeHTML(for: index, section: section, context: context)
    }
    
    func makeSectionHTML(for section: Section<SwiftBlog>, context: PublishingContext<SwiftBlog>) throws -> HTML {
        if section.id.rawValue == "home" {
            return try makeIndexHTML(for: context.index, context: context)
        }
        if section.id.rawValue == "posts" {
            return try makePostsHTML(for: section, context: context)
        }
        if section.id.rawValue == "tags" {
            return try makeTagsHTML(for: section, context: context)
        }
        
        return HTML(
            .text("Page does not exist.")
        )
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<SwiftBlog>) throws -> HTML {
        try makeIndexHTML(for: context.index, context: context)
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<SwiftBlog>) throws -> HTML? {
        nil
    }
    
}
