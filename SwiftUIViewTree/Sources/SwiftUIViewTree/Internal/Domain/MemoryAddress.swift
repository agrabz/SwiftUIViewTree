
enum MemoryAddress {
    enum OpeningChars {
        static let first: Character = "0"
        static let second: Character = "x"
    }

    enum TerminatorChars: Character, CaseIterable {
        case space = " "
        case x = ">"
    }

    enum LookUpResult {
        case found(index: Int)
        case invalidMemoryAddress
        case notFound
    }

    static func hasDiffInMemoryAddress(lhs: String, rhs: String) -> Bool {
        guard lhs != rhs else { return false }

        let lhsStringElementArray = Array(lhs)
        let rhsStringElementArray = Array(rhs)
        let maxLength = max(lhsStringElementArray.count, rhsStringElementArray.count)

        for index in 0..<maxLength {
            let lhsChar = index < lhsStringElementArray.count ? lhsStringElementArray.safeGetElement(at: index) : nil
            let rhsChar = index < rhsStringElementArray.count ? rhsStringElementArray.safeGetElement(at: index) : nil

            if lhsChar != rhsChar {
                if isInsideMemoryAddress(fullString: lhs, at: index) || isInsideMemoryAddress(fullString: rhs, at: index) {
                    return true
                }
            }
        }

        return false
    }

    static func isInsideMemoryAddress(fullString: String, at indexToStartCheckingFrom: Int) -> Bool { //TODO: implementation could be simplified by taking into account that a 62bit memory address is always 2+16 character long
        let stringElementArray = Array(fullString)

        guard indexToStartCheckingFrom < stringElementArray.count else { return false }

        let result = lookBackwardForMemoryStartChars(indexToStartCheckingFrom: indexToStartCheckingFrom, stringElementArray: stringElementArray)

        return switch result {
            case .found(let index):
                isValidMemoryAddress(indexToStartCheckingFrom: index, fullStringAsElementArray: stringElementArray)
            case .invalidMemoryAddress, .notFound:
                false
        }
    }

    static func lookBackwardForMemoryStartChars(indexToStartCheckingFrom: Int, stringElementArray: [Character]) -> MemoryAddress.LookUpResult {
        for index in stride(from: indexToStartCheckingFrom, through: 0, by: -1) {
            if indexMatchesMemoryAddressStart(index: index, stringElementArray: stringElementArray) {
                return .found(index: index - 1)
            }

            if isTerminationCharacter(stringElementArray: stringElementArray, index: index) {
                return .invalidMemoryAddress
            }
        }

        return .notFound
    }

    static func indexMatchesMemoryAddressStart(index: Int, stringElementArray: [Character]) -> Bool {
        index > 0 &&
        stringElementArray.safeGetElement(at: index-1) == MemoryAddress.OpeningChars.first &&
        stringElementArray.safeGetElement(at: index) == MemoryAddress.OpeningChars.second
    }

    static func isValidMemoryAddress(indexToStartCheckingFrom: Int, fullStringAsElementArray stringElementArray: [Character]) -> Bool {
        for index in (indexToStartCheckingFrom+1)..<stringElementArray.count {
            if isTerminationCharacter(stringElementArray: stringElementArray, index: index) {
                return true
            }

            if isNotValidMemoryAddressCharacter(stringElementArray: stringElementArray, index: index) {
                return false
            }
        }

        // End of string is also valid termination
        return true
    }

    static func isTerminationCharacter(stringElementArray: [Character], index: Int) -> Bool {
        let terminatorChars = MemoryAddress.TerminatorChars.allCases.map(\.rawValue)

        for terminatorChar in terminatorChars {
            if stringElementArray.safeGetElement(at: index) == terminatorChar {
                return true
            }
        }

        return false
    }

    static func isNotValidMemoryAddressCharacter(stringElementArray: [Character], index: Int) -> Bool {
        let isHex = stringElementArray.safeGetElement(at: index)?.isHexDigit == true

        return !isHex && stringElementArray.safeGetElement(at: index) != MemoryAddress.OpeningChars.second
    }
}
