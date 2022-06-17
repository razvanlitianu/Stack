import XCTest
@testable import Stack

final class StackTests: XCTestCase {
    var sut: Stack!
    
    override func setUp() {
        sut = try! BoundedStack.make(capacity: 2)
    }
    
    func testNewlyCreatedStack_ShouldBeEmpty() {
        XCTAssertTrue(sut.isEmpty)
        XCTAssertEqual(sut.size, 0)
    }
    
    func testAfterOnePush_StackSizeShouldBeOne() throws {
        try sut.push(1)
        XCTAssertEqual(sut.size, 1)
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testAfterOnePushOnePop_ShouldBeEmpty() throws {
        try sut.push(1)
        try sut.pop()
        XCTAssertTrue(sut.isEmpty)
    }
    
    func testWhenPushedPastLimit_StackOverflows() throws {
        try sut.push(1)
        try sut.push(1)
        
        assert(try sut.push(1), throws: BoundedStack.Error.overflow)
    }
    
    func testWhenEmptyStackIsPoped_StackUnderflows() throws {
        assert(try sut.pop(), throws: BoundedStack.Error.underflow)
    }
    
    func testWhenOneIsPushed_OneIsPopped() throws {
        try sut.push(1)
        XCTAssertEqual(try sut.pop(), 1)
    }
    
    func testWhenOneAndTwoArePushed_TwoAndOneArePopped() throws {
        try sut.push(1)
        try sut.push(2)
        XCTAssertEqual(try sut.pop(), 2)
        XCTAssertEqual(try sut.pop(), 1)
    }
    
    func testWhenCreatingStackWithNegativeSize_ShouldThrowIllegalCapacity() {
        assert(try BoundedStack.make(capacity: -1), throws: BoundedStack.Error.illegalCapacity)
    }
    
    func testWhenCreatingStackWithZeroCapacity_AnyPushShouldOverflow() {
        sut = try! BoundedStack.make(capacity: 0)
        assert(try sut.push(1), throws: BoundedStack.Error.overflow)
        
    }
    
    func testWhenOneIsPushed_OneIsOnTop() throws {
        try sut.push(1)
        XCTAssertEqual(sut.top(), 1)
    }
    
    func testWhenStackIsEmpty_TopIsEmpty() {
        XCTAssertNil(sut.top())
    }
    
    func testWithZeroCapacityStack_TopIsEmpty() throws {
        sut = try BoundedStack.make(capacity: 0)
        XCTAssertNil(sut.top())
    }
    
    func testGivenStackWithOneAndTwoPushed_FindOneAndTwo() throws {
        try sut.push(1)
        try sut.push(2)
        
        XCTAssertEqual(sut.find(2), 1)
        XCTAssertEqual(sut.find(1), 0)
    }
    
    func testGivenStackWithNoTwoFind_FindShouldReturnNil() {
        XCTAssertNil(sut.find(2))
    }
}


