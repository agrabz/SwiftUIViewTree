
struct AtomicBoxTypeTreeNodeValidator: TreeNodeValidatorProtocol {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError) {
        if "\(type(of: child.value))".starts(with: "AtomicBox") {
            throw .atomicBox
        }
    }
}
