import AlfredWorkflowScriptFilter
import AppKit


public enum Workflow {
    
    public static func setURLCache() {
        if let alfredWorkflowCache = ProcessInfo.processInfo.environment["alfred_workflow_cache"] {
            try? FileManager.default.createDirectory(atPath: alfredWorkflowCache, withIntermediateDirectories: false)
            // URLCache diskPath is deprecated, but Apple doesn't seem to have a replacement yet.
            // if using directory, we can't get a URL working with "Workflow Data" because of the space. we can
            // get a functioning URL with fileURLWithPath but once we pass it to URLCache, it will create a
            // "Workflow%20Data" folder. same with using the new FilePath. currently it doesn't seem there's
            // a replacement, hence using diskPath until it's fully removed by Apple, which will surely have provided
            // a solution by then.
            URLCache.shared = URLCache(memoryCapacity: 1_000_000, diskCapacity: 10_000_000, diskPath: alfredWorkflowCache)
        } else {
            URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, directory: nil)
        }
    }
    
    public static func next() -> String {
        ProcessInfo.processInfo.environment["next"] ?? "oops"
    }

    public static func menu(for brookVPN: BrookVPNProtocol = BrookVPN()) -> String {
        Entrance.scriptFilter(for: brookVPN)
    }

    public static func `do`() -> Bool {
        let action = ProcessInfo.processInfo.environment["action"]
        let vpn = ProcessInfo.processInfo.environment["vpn"] ?? ""

        switch action {
        case "connect":
            connect(vpn: vpn)
            
            return true
        case "disconnect":
            disconnect(vpn: vpn)
                        
            return true
        case "download":
            if let url = URL(string: "https://apps.apple.com/us/app/brook-network-tool/id1216002642") {
                NSWorkspace.shared.open(url)
            }
            
            return false
        default:
            print("what action?")
            return false
        }
    }

    public static func notify(resultFrom _: Bool = false) -> String {
        let action = ProcessInfo.processInfo.environment["action"]
        let vpn = ProcessInfo.processInfo.environment["vpn"] ?? ""

        switch action {
        case "connect":
            return "\(vpn) is connecting..."
        case "disconnect":
            return "\(vpn) has disconnected"
        case "download":
            return ""
        case "update":
            return ""
        case "go_release_page":
            return ""
        default:
            return "huh. wtf?"
        }
    }

}


// TODO:
// * tests
// * refactor so that it's testable and not a big pile of shit
// * add fucking Updater


extension Workflow {
    
    private static func connect(vpn: String) {
        let pipe = Pipe()

        let scutil = Process()
        scutil.standardOutput = pipe
        scutil.standardError = pipe
        scutil.arguments = ["-c", #"scutil --nc start "\#(vpn)""#]
        scutil.launchPath = "/bin/zsh"
        scutil.standardInput = nil
        scutil.launch()
    }
    
    private static func disconnect(vpn: String) {
        let pipe = Pipe()

        let scutil = Process()
        scutil.standardOutput = pipe
        scutil.standardError = pipe
        scutil.arguments = ["-c", #"scutil --nc stop "\#(vpn)""#]
        scutil.launchPath = "/bin/zsh"
        scutil.standardInput = nil
        scutil.launch()
    }

}
