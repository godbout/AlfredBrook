@testable import AlfredBrookCore
import XCTest

class WorkflowTests: AlfredBrookTestCase {
    
    func test_that_if_there_is_no_Brook_VPN_installed_then_it_tells_you_that_LOL() {
        XCTAssertTrue(
            Workflow.menu(for: BrookVPNNotInstalledMock()).contains("no Brook VPN found")
        )
    }
    
    func test_that_if_there_is_a_Brook_VPN_installed_and_not_connected_it_allows_connection() {
        XCTAssertTrue(
            Workflow.menu(for: BrookVPNNotConnectedMock()).contains(#""title":"connect""#)
        )
    }
        
    func test_that_if_there_is_a_Brook_VPN_installed_and_connected_it_allows_disconnection() {
        XCTAssertTrue(
            Workflow.menu(for: BrookVPNConnectedMock()).contains(#""title":"disconnect""#)
        )
    }

}
