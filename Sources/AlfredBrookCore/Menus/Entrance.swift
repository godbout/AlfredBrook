import AlfredWorkflowScriptFilter
import Foundation


class Entrance {
    
    static let shared = Entrance()

    private init() {}

    
    static func userQuery() -> String {
        CommandLine.arguments[1]
    }

    static func scriptFilter() -> String {
        results(for: userQuery())
    }

    static func results(for query: String) -> String {
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
        
        do {
            let vpns = brookVPNs(for: query)

            return menuFor(vpns: vpns)
        } catch {
            return ScriptFilter.add(Item(title: "you've reached the end of why the Workflow doesn't work. i don't seem to know 👀️")).output()
        }
    }
    
    static func brookVPNs(for query: String) -> String {
        let pipe = Pipe()

        let scutil = Process()
        scutil.standardOutput = pipe
        scutil.standardError = pipe
        scutil.arguments = ["-c", #"scutil --nc list | grep "com.txthinking.brook" | awk -F'"' '{print$2}'"#]
        scutil.launchPath = "/bin/zsh"
        scutil.standardInput = nil
        scutil.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        print("hehe")
        print(output)
        
        return output
    }

}


extension Entrance {
    
    private static func menuFor(vpns: String) -> String {
        return ScriptFilter.output()
    }

}
