import Foundation
import XCTest

class JetpackBackupOptionsScreen: BaseScreen {

    init() {
        super.init(element: XCUIApplication().otherElements.firstMatch)
    }
}
