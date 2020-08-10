//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/25/20.
//


import Foundation
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func myFooter<T: Website>(for site: T) -> Node {
        let currentYear = Calendar.current.component(.year, from: Date())
        return
            .wrapper(
                .class("footer"),
                .div(
                    .text("© \(currentYear) \(site.name)")
                ),
                .div(
                    .text("Generated using "),
                    .a(
                        .text("Publish"),
                        .href("https://github.com/johnsundell/publish")
                    ),
                    .text(". Written in Swift")
                ),
                .class("footer-social"),
                .div(
                    .a(
                        .text("LinkedIn"),
                        .href("https://www.linkedin.com/in/thomas-kellough/")
                    ),
                    .text(" | "),
                    .a(
                        .text("Github"),
                        .href("https://github.com/thomaskellough")
                    ),
                    .text(" | "),
                    .a(
                        .text("Email"),
                        .href("mailto:theswiftprotocol@gmail.com")
                    )
                )
        )
    }
}
