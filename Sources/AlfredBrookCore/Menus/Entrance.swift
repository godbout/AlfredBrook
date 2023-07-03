import AlfredWorkflowScriptFilter
import Foundation


class Entrance {
    
    static let shared = Entrance()

    private init() {}


    static func scriptFilter(for brookVPN: BrookVPNProtocol) -> String {
        results(for: brookVPN)
    }

    static func results(for brookVPN: BrookVPNProtocol) -> String {
        let brookVPNName = brookVPN.name()

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
        
        if brookVPNName.isEmpty {
            ScriptFilter.add(
                Item(title: "no Brook VPN found ☹️")
                    .subtitle("You need to install Brook and set up your VPN first. Press return now!")
                    .arg("do")
                    .variable(Variable(name: "action", value: "download"))
            )
        } else {
            switch brookVPN.status(for: brookVPNName) {
            case .connected:
                ScriptFilter.add(
                    Item(title: "disconnect")
                        .subtitle(brookVPNName)
                        .arg("do")
                        .variable(Variable(name: "action", value: "disconnect"))
                        .variable(Variable(name: "vpn", value: brookVPNName))
                        .icon(Icon(path: "./resources/icons/disconnect.png"))
                )
            case .notConnected:
                ScriptFilter.add(
                    Item(title: "connect")
                        .subtitle(brookVPNName)
                        .arg("do")
                        .variable(Variable(name: "action", value: "connect"))
                        .variable(Variable(name: "vpn", value: brookVPNName))
                        .icon(Icon(path: "./resources/icons/connect.png"))
                )
            }
        }
        
        return ScriptFilter.output()
    }
        

}
