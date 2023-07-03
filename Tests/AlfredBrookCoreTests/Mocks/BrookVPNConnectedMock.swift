import Foundation
@testable import AlfredBrookCore


public struct BrookVPNConnectedMock: BrookVPNProtocol {
    
    public func name() -> String {
        "com.txthinking.brook"
    }
    
    public func status(for name: String) -> VPNStatus {
        .connected
    }

}
