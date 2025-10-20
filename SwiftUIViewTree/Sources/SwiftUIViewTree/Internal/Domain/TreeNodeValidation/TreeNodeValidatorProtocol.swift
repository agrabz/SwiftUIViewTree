
protocol TreeNodeValidatorProtocol {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError)
}
