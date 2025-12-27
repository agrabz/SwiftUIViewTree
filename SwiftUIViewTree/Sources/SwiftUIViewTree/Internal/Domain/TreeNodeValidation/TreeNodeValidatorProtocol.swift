
protocol TreeNodeValidatorProtocol: Sendable {
    func validate(_ child: Mirror.Child) throws(TreeNodeValidationError)
}
