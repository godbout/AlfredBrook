@testable import AlfredBrookCore
import XCTest

class NotificationsTests: AlfredKatTestCase {
    
    func test_that_it_can_notify_when_the_VPN_is_connecting() {
        Self.setEnvironmentVariable(name: "action", value: "dickLOL")
            
        XCTAssertTrue(
            Workflow.notify() == "TxThinking Brook macOS is connecting..."
        )
    }
        
    func test_that_it_can_notify_when_the_VPN_has_disconnected() {
        Self.setEnvironmentVariable(name: "action", value: "dickLOL")
            
        XCTAssertTrue(
            Workflow.notify() == "TxThinking Brook macOS is connecting..."
        )
    }

}
