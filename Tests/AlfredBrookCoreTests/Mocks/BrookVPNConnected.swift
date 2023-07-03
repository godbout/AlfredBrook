import Foundation
@testable import AlfredBrookCore


public struct BrookVPNConnected: BrookVPNProtocol {
    
    public func name() -> String {
        "com.txthinking.brook"
    }
    
    public func status(for name: String) -> VPNStatus {
        .connected
    }

}
