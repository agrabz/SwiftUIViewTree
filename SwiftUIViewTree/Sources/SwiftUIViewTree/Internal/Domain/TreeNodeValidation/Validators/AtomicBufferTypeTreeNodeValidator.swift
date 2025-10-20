
struct AtomicBufferTypeTreeNodeValidator: TreeNodeValidatorProtocol {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError) {
        if "\(type(of: child.value))".starts(with: "AtomicBuffer") {
            throw .atomicBox
        }
    }
}
