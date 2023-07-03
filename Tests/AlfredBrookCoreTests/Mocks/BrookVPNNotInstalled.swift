import Foundation
@testable import AlfredBrookCore


public struct BrookVPNNotInstalled: BrookVPNProtocol {
    
    public func name() -> String {
        ""
    }
    
    public func status(for name: String) -> VPNStatus {
        .notConnected
    }

}
