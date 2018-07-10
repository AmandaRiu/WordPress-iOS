/// Base Notification Action Command
class DefaultNotificationActionCommand: FormattableContentActionCommand {
    var on: Bool

    var identifier: Identifier {
        return type(of: self).commandIdentifier()
    }

    private(set) lazy var mainContext: NSManagedObjectContext? = {
        return ContextManager.sharedInstance().mainContext
    }()

    private(set) lazy var actionsService: NotificationActionsService? = {
        return NotificationActionsService(managedObjectContext: mainContext!)
    }()

    var icon: UIButton? {
        return nil
    }

    public init(on: Bool) {
        self.on = on
    }

    func execute(context: ActionContext) { }

    func setIconTitle(_ title: String) {
        icon?.setTitle(title, for: .normal)
    }

    func setAccessibilityLabel(_ title: String) {
        icon?.accessibilityLabel = title
    }

    func setAccessibilityHint(_ hint: String) {
        icon?.accessibilityHint = hint
    }

}
