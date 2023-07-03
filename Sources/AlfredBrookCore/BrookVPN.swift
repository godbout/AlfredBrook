import Foundation


public enum VPNStatus {
    
    case connected
    case notConnected
    
}

public protocol BrookVPNProtocol {

    func name() -> String
    func status(for name: String) -> VPNStatus
    
}


public struct BrookVPN: BrookVPNProtocol {
    
    public init() {}
    

    public func name() -> String {
        let pipe = Pipe()

        let scutil = Process()
        scutil.standardOutput = pipe
        scutil.standardError = pipe
        scutil.arguments = ["-c", #"scutil --nc list | grep "com.txthinking.brook" | awk -F'"' '{print$2}'"#]
        scutil.launchPath = "/bin/zsh"
        scutil.standardInput = nil
        scutil.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) else { return "" }
        
        return output
    }
    
    public func status(for name: String) -> VPNStatus {
        let pipe = Pipe()
        
        let scutil = Process()
        scutil.standardOutput = pipe
        scutil.standardError = pipe
        scutil.arguments = ["-c", #"scutil --nc status "\#(name)" | head -n 1 | grep -i "connected""#]
        scutil.launchPath = "/bin/zsh"
        scutil.standardInput = nil
        scutil.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) else { return .notConnected }
               
        return output == "Connected" ? .connected : .notConnected
    }

}
