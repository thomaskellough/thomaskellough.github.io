//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func myHeader<T: Website>(for context: PublishingContext<T>) -> Node {
        .header(
            .wrapper(
                .class("nav-logo"),
                .a(
                    .href("/"),
                    .img(.src(SwiftBlog.logoImagePath))
                ), // a
                .nav(
                    .p(.text("Swift Skill Building With Thomas Kellough")),
                    .class("nav-bar"),
                    .ul(
                        .forEach(
                            SwiftBlog.navItems
                        ) { item in
                            .li(
                                .h3(
                                    .a(
                                        .href("/\(item.lowercased())"),
                                        .text(item)
                                    ) // a
                                ) // h3
                            ) // li
                        } // forEach
                    ) // ul
                ) // nav
            ) // wrapper
        ) // header
    }
}
