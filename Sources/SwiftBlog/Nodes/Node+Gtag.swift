//
//  File.swift
//  
//
//  Created by Thomas Kellough on 8/15/20.
//

import Plot
import Publish

public extension Node where Context == HTML.HeadContext {
    static func gTag(_ trackingID: String) -> Node {
        return group([
            .script(.async(), .src("https://www.googletagmanager.com/gtag/js?id=\(trackingID)")),
            .script("window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments);}gtag('js', new Date());gtag('config', '\(trackingID)');")
        ])
        
    }
}
