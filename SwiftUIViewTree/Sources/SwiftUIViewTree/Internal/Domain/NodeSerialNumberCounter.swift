
actor NodeSerialNumberCounter {
    private var _nodeSerialNumberCounter = 0
    var counter: Int {
        get {
            _nodeSerialNumberCounter += 1
            return _nodeSerialNumberCounter
        }
    }

    func reset() {
        _nodeSerialNumberCounter = 0
    }
}

