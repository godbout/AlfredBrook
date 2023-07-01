@testable import AlfredBrookCore
import XCTest

class NotificationsTests: AlfredBrookTestCase {
    
    func test_that_it_can_notify_when_the_VPN_is_connecting() {
        Self.setEnvironmentVariable(name: "action", value: "connect")
        Self.setEnvironmentVariable(name: "vpn", value: "VPN Name")

        XCTAssertTrue(
            Workflow.notify() == "VPN Name is connecting..."
        )
    }
        
    func test_that_it_can_notify_when_the_VPN_has_disconnected() {
        Self.setEnvironmentVariable(name: "action", value: "disconnect")
        Self.setEnvironmentVariable(name: "vpn", value: "VPN Name")

        XCTAssertTrue(
            Workflow.notify() == "VPN Name has disconnected"
        )
    }
    
    func test_that_there_is_no_notification_when_it_sends_to_the_Mac_App_Store() {
        Self.setEnvironmentVariable(name: "action", value: "download")

        XCTAssertEqual(Workflow.notify(), "")
    }
    
    func test_that_there_is_no_notification_when_it_downloads_a_Workflow_update() {
        Self.setEnvironmentVariable(name: "action", value: "update")

        XCTAssertEqual(Workflow.notify(), "")
    }

    func test_that_there_is_no_notification_when_it_goes_to_an_Update_Release_Page() {
        Self.setEnvironmentVariable(name: "action", value: "go_release_page")

        XCTAssertEqual(Workflow.notify(), "")
    }

}
