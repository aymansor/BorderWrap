import XCTest
@testable import BorderWrap

final class BorderWrapTests: XCTestCase {
    func testWrapBorder() {
        let wrapper = BorderWrap(minWidth: 10, maxWidth: 20)
        let input = [
            "This is a test string",
            "with multiple lines",
            "and some lines are quite long"
        ]
        
        let output = wrapper.wrapBorder(around: input[0], input[1], input[2])
        let expectation = """
        ┌────────────────────┐
        │   This is a test   │
        │       string       │
        │with multiple lines │
        │ and some lines are │
        │     quite long     │
        └────────────────────┘\n
        """

        XCTAssertEqual(output, expectation)
    }
    
    func testWrapBorder_minWidthOnly() {
        let wrapper = BorderWrap(minWidth: 40)
        let input = [
            "This is a test string",
            "with multiple lines",
            "and some lines are quite long"
        ]
        
        let output = wrapper.wrapBorder(around: input[0], input[1], input[2])
        let expectation = """
        ┌────────────────────────────────────────┐
        │         This is a test string          │
        │          with multiple lines           │
        │     and some lines are quite long      │
        └────────────────────────────────────────┘\n
        """

        XCTAssertEqual(output, expectation)
    }

    func testWrapBorder_maxWidthOnly() {
        let wrapper = BorderWrap(maxWidth: 15)
        let input = [
            "This is a test string",
            "with multiple lines",
            "and some lines are quite long"
        ]
        
        let output = wrapper.wrapBorder(around: input[0], input[1], input[2])
        let expectation = """
        ┌───────────────┐
        │This is a test │
        │    string     │
        │ with multiple │
        │     lines     │
        │and some lines │
        │are quite long │
        └───────────────┘\n
        """

        XCTAssertEqual(output, expectation)
    }
    
    func testWrapBorder_longWordsWithHyphen() {
        let wrapper = BorderWrap(maxWidth: 10)
        let input = [
            "This is a test string with a verylongwordthatneedstobesplit",
            "with multiple lines",
            "and some lines are quite long"
        ]
        
        let output = wrapper.wrapBorder(around: input[0], input[1], input[2])
        let expectation = """
        ┌──────────┐
        │This is a │
        │   test   │
        │  string  │
        │  with a  │
        │verylongw-│
        │ordthatne-│
        │edstobesp-│
        │   lit    │
        │   with   │
        │ multiple │
        │  lines   │
        │ and some │
        │lines are │
        │quite long│
        └──────────┘\n
        """

        XCTAssertEqual(output, expectation)
    }
    
    func testWrapBorder_includeNewLine() {
        let wrapper = BorderWrap()
        let input = [
            "This is \na test string",
            "with multiple lines\n",
            "and some lines are quite long"
        ]
        
        let output = wrapper.wrapBorder(around: input[0], input[1], input[2])
        let expectation = """
        ┌─────────────────────────────┐
        │           This is           │
        │        a test string        │
        │     with multiple lines     │
        │                             │
        │and some lines are quite long│
        └─────────────────────────────┘\n
        """

        XCTAssertEqual(output, expectation)
    }

}
