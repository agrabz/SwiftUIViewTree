
extension Array {
    func safeGetElement(at index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}

extension Array {
    func safeGetSubSequence(in range: ClosedRange<Int>) -> SubSequence? {
        guard self.indices.contains(range) else {
            return nil
        }
        return self[range]
    }

    func safeGetSubSequenceOrEmpty(in range: ClosedRange<Int>) -> SubSequence {
        guard let subSequence = self.safeGetSubSequence(in: range) else {
            return []
        }
        return subSequence
    }
}

extension Array {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
