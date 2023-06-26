import AlfredWorkflowScriptFilter
import Foundation


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

    public static func menu() -> String {
        Entrance.scriptFilter()
    }

    public static func `do`() -> Bool {
        let action = ProcessInfo.processInfo.environment["action"]
        let torrentPageLink = ProcessInfo.processInfo.environment["torrent_page_link"] ?? ""

        switch action {
        case "download":
            return false
        case "copy":
            return false
        default:
            return false
        }
    }

    public static func notify(resultFrom _: Bool = false) -> String {
        let action = ProcessInfo.processInfo.environment["action"]
        let torrentName = ProcessInfo.processInfo.environment["torrent_name"] ?? "some porn"

        switch action {
        case "download":
            return "download"
        case "copy":
            return "copy"
        case "update":
            return ""
        case "go_release_page":
            return ""
        default:
            return "huh. wtf?"
        }
    }

}
