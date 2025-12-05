
struct AtomicBufferTypeTreeNodeValidator: TreeNodeValidatorProtocol {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError) {
        if "\(type(of: child.value))".starts(with: "AtomicBuffer") {
            throw .atomicBuffer
        }
    }
}

struct LocalizedTextStorageTreeNodeValidator: TreeNodeValidatorProtocol {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError) {
//        if "\(type(of: child.value))".contains("LocalizedTextStorage") {
//            throw .localizedTextStorage
//        }
    }
}

struct StorageTreeNodeValidator: TreeNodeValidatorProtocol {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError) {
//        if "\(child.value))".contains("Storage") {
//            throw .storage
//        }
    }
}
