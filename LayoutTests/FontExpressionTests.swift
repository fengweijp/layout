//  Copyright © 2017 Schibsted. All rights reserved.

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

    func testBoldUnescapedFontNameWithSpaces() {
        let node = LayoutNode()
        let name = "helvetica neue"
        let expression = LayoutExpression(fontExpression: "\(name) bold", for: node)
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

    func testNilFont() {
        let font: UIFont? = nil
        let node = LayoutNode(constants: ["font": font as Any])
        let expression = LayoutExpression(fontExpression: "{font} bold", for: node)
        XCTAssertThrowsError(try expression.evaluate()) { error in
            XCTAssert("\(error)".contains("nil"))
        }
    }

    func testFontTextStyle() {
        let node = LayoutNode()
        let expression = LayoutExpression(fontExpression: "caption1", for: node)
        let expected = UIFont.preferredFont(forTextStyle: .caption1)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testCustomFontTextStyle() {
        let node = LayoutNode()
        let name = "courier"
        let expression = LayoutExpression(fontExpression: "\(name) title1", for: node)
        let expectedSize = UIFont.preferredFont(forTextStyle: .title1).pointSize
        let expected = UIFont(name: name, size: expectedSize)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testFontSize() {
        let node = LayoutNode()
        let expression = LayoutExpression(fontExpression: "19", for: node)
        let expected = UIFont.systemFont(ofSize: 19)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testRelativeFontSize() {
        let node = LayoutNode()
        let expression = LayoutExpression(fontExpression: "150%", for: node)
        let expected = UIFont.systemFont(ofSize: LayoutExpression.defaultFontSize * 1.5)
        XCTAssertEqual(try expression.evaluate() as? UIFont, expected)
    }

    func testFontTextStyleWithRelativeSize() {
        let node = LayoutNode()
        let expression = LayoutExpression(fontExpression: "body 150%", for: node)
        let expectedSize = UIFont.preferredFont(forTextStyle: .body).pointSize * 1.5
        XCTAssertEqual((try expression.evaluate() as? UIFont)?.pointSize, expectedSize)
    }
}
