import AlfredWorkflowScriptFilter
import Foundation


enum VPNStatus {
    
    case connected
    case notConnected
    
}


class Entrance {
    
    static let shared = Entrance()

    private init() {}

    
    static func scriptFilter() -> String {
        results()
    }

    static func results() -> String {
        // TODO: probably should be at the end of the Alfred Results
        if let release = Updater.updateAvailable() {
            ScriptFilter.add(
                Item(title: "update available! (\(release.version))")
                    .subtitle("press Enter to update, or Command Enter to take a trip to the release page")
                    .arg("do")
                    .variable(Variable(name: "AlfredWorkflowUpdater_action", value: "update"))
                    .mod(
                        Cmd()
                            .subtitle("say hello to the release page")
                            .arg("do")
                            .variable(Variable(name: "AlfredWorkflowUpdater_action", value: "open"))
                    )
            )
        }
        
        let brookVPN = brookVPN()

        if brookVPN.isEmpty {
            ScriptFilter.add(
                Item(title: "no Brook VPN found ☹️")
                    .subtitle("You need to install Brook and set up your VPN first. Press return now!")
                    .arg("do")
                    .variable(Variable(name: "action", value: "download"))
            )
        } else {
            switch vpnStatus(of: brookVPN) {
            case .connected:
                ScriptFilter.add(
                    Item(title: "disconnect")
                        .subtitle(brookVPN)
                        .arg("do")
                        .variable(Variable(name: "action", value: "disconnect"))
                        .variable(Variable(name: "vpn", value: brookVPN))
                        .icon(Icon(path: "./resources/icons/disconnect.png"))
                )
            case .notConnected:
                ScriptFilter.add(
                    Item(title: "connect")
                        .subtitle(brookVPN)
                        .arg("do")
                        .variable(Variable(name: "action", value: "connect"))
                        .variable(Variable(name: "vpn", value: brookVPN))
                        .icon(Icon(path: "./resources/icons/connect.png"))
                )
            }
        }
        
        return ScriptFilter.output()
    }
        
    static func brookVPN() -> String {
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

    static func vpnStatus(of vpn: String) -> VPNStatus {
        let pipe = Pipe()
        
        let scutil = Process()
        scutil.standardOutput = pipe
        scutil.standardError = pipe
        scutil.arguments = ["-c", #"scutil --nc status "\#(vpn)" | head -n 1 | grep -i "connected""#]
        scutil.launchPath = "/bin/zsh"
        scutil.standardInput = nil
        scutil.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) else { return .notConnected }
               
        return output == "Connected" ? .connected : .notConnected
    }
    
}


extension Entrance {
    
    private static func menuFor(brookVPN: String) -> String {
        ScriptFilter.item(Item(title: brookVPN))
        
        return ScriptFilter.output()
    }

}
