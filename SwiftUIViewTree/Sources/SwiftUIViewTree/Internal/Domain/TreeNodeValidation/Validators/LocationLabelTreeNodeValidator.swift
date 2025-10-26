
struct LocationLabelTreeNodeValidator: TreeNodeValidatorProtocol {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError) {
        if child.label == TreeNodeValidationError.location.rawValue {
            throw .location
        }
    }
}
