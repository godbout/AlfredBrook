import Foundation
@testable import AlfredBrookCore


public struct BrookVPNNotInstalledMock: BrookVPNProtocol {
    
    public func name() -> String {
        ""
    }
    
    public func status(for name: String) -> VPNStatus {
        .notConnected
    }

}
