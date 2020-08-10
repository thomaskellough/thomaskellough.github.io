//
//  File.swift
//  
//
//  Created by Thomas Kellough on 7/23/20.
//

import Publish
import Plot


extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }
}
