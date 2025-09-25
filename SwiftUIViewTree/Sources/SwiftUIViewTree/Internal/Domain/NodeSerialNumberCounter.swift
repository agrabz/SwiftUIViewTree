
@MainActor
struct NodeSerialNumberCounter {
    private var _nodeSerialNumberCounter = 0
    var counter: Int {
        mutating get {
            _nodeSerialNumberCounter += 1
            return _nodeSerialNumberCounter
        }
    }

    mutating func reset() {
        _nodeSerialNumberCounter = 0
    }
}

