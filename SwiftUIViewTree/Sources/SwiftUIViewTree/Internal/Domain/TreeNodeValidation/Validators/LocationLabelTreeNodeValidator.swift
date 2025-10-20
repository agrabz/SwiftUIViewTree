
struct LocationLabelTreeNodeValidator: TreeNodeValidatorProtocol {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError) {
        if child.label == "location" {
            throw .location
        }
    }
}
