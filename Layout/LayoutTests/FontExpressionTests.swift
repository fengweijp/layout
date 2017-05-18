//
//  FontExpressionTests.swift
//  Layout
//
//  Created by Nick Lockwood on 17/05/2017.
//  Copyright © 2017 Nick Lockwood. All rights reserved.
//

import XCTest
@testable import Layout

class FontExpressionTests: XCTestCase {
    
    func testBold() {
        let node = LayoutNode()
        let expression = LayoutExpression(fontExpression: "bold", for: node)
        let expected = UIFont.boldSystemFont(ofSize: LayoutExpression.defaultFontSize)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testBoldItalic() {
        let node = LayoutNode()
        let expression = LayoutExpression(fontExpression: "bold italic", for: node)
        let descriptor = UIFont.systemFont(ofSize: 17).fontDescriptor
        let traits = descriptor.symbolicTraits.union([.traitBold, .traitItalic])
        let expected = UIFont(descriptor: descriptor.withSymbolicTraits(traits)!, size: LayoutExpression.defaultFontSize)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testFontName() {
        let node = LayoutNode()
        let name = "helvetica"
        let expression = LayoutExpression(fontExpression: name, for: node)
        let expected = UIFont(name: name, size: LayoutExpression.defaultFontSize)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testEscapedFontNameWithSpaces() {
        let node = LayoutNode()
        let name = "helvetica neue"
        let expression = LayoutExpression(fontExpression: "'\(name)'", for: node)
        let expected = UIFont(name: name, size: LayoutExpression.defaultFontSize)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testBoldEscapedFontNameWithSpaces() {
        let node = LayoutNode()
        let name = "helvetica neue"
        let expression = LayoutExpression(fontExpression: "'\(name)' bold", for: node)
        let descriptor = UIFont(name: name, size: LayoutExpression.defaultFontSize)!.fontDescriptor
        let traits = descriptor.symbolicTraits.union([.traitBold])
        let expected = UIFont(descriptor: descriptor.withSymbolicTraits(traits)!, size: LayoutExpression.defaultFontSize)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testExplicitFontWithBoldAttributes() {
        let font = UIFont(name: "courier", size: 15)!
        let node = LayoutNode(constants: ["font": font])
        let expression = LayoutExpression(fontExpression: "{font} bold", for: node)
        let descriptor = font.fontDescriptor
        let traits = descriptor.symbolicTraits.union([.traitBold])
        let expected = UIFont(descriptor: descriptor.withSymbolicTraits(traits)!, size: font.pointSize)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }
}