protocol Stack {
    var isEmpty: Bool { get }
    var size: Int { get }
    mutating func push(_ element: Int) throws
    @discardableResult
    mutating func pop() throws -> Int
    // I think it's more appropriate to return nil as absence of a value
    func top() -> Int?
    func find(_ element: Int) -> Int?
}

public struct BoundedStack: Stack {

    var size = 0
    let capacity: Int
    var isEmpty: Bool { size == 0 }
    private var elements: [Int]
    
    private init(capacity: Int) {
        self.capacity = capacity
        self.elements = []
    }
    
    static func make(capacity: Int) throws -> Stack {
        if capacity < 0 { throw Error.illegalCapacity }
        if capacity == 0 { return ZeroCapacityStack() }
        return BoundedStack(capacity: capacity)
    }
    
    mutating func push(_ element: Int) throws {
        if size == capacity { throw Error.overflow }
        size += 1
        self.elements.append(element)
    }
    
    @discardableResult
    mutating func pop() throws -> Int {
        if size == 0 { throw Error.underflow }
        size -= 1
        return elements[size]
    }
    
    func top() -> Int? {
        if size == 0 { return nil }
        return elements[size - 1]
    }
    
    func find(_ element: Int) -> Int? {
        elements.firstIndex(of: element)
    }
}

extension BoundedStack {
    enum Error: Swift.Error {
        case overflow
        case underflow
        case illegalCapacity
    }
}

private extension BoundedStack {
    struct ZeroCapacityStack: Stack {
        var isEmpty: Bool = true
        var size: Int = 0
        
        mutating func push(_ element: Int) throws {
            throw Error.overflow
        }
        
        mutating func pop() throws -> Int {
            throw Error.underflow
        }
        
        func top() -> Int? {
            return nil
        }
        
        func find(_ element: Int) -> Int? {
            return nil
        }
    }
}
