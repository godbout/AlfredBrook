import XCTest
@testable import AlfredBrookCore


class AlfredBrookTestCase: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        
        mockAlfredWorkflowUID()  
        mockAlfredWorkflowCacheFolder()
    }
    
    override func setUp() {
        super.setUp()

        Self.resetEnvironmentVariables()
        try? Self.removeAlreadyCreatedUpdateInfoFile()
    }

}


extension AlfredBrookTestCase {

    static var updateAvailableFile: String? {
        guard let alfredWorkflowCache = ProcessInfo.processInfo.environment["alfred_workflow_cache"] else { return nil }
        
        return "\(alfredWorkflowCache)/update_available.plist"
    }
    
    static func setEnvironmentVariable(name: String, value: String) {
        setenv(name, value, 1)
    }
    
    static func resetEnvironmentVariables() {
        Self.setEnvironmentVariable(name: "action", value: "")
    }
    
    static func mockAlreadyCreatedReleaseInfoFile() throws {
        let updateAvailableFile = try XCTUnwrap(Self.updateAvailableFile)
        
        let releaseInfo = ReleaseInfo(
            version: "doesn't matter",
            file: "doesn't matter either",
            page: "we just need the file to be there to show the update in Alfred Results"
        )
        
        let encoder = PropertyListEncoder()
        guard let encoded = try? encoder.encode(releaseInfo) else { return XCTFail() }
        
        FileManager.default.createFile(atPath: updateAvailableFile, contents: encoded)
    }
    
}


extension AlfredBrookTestCase {
    
    private static func mockAlfredWorkflowUID() {
        Self.setEnvironmentVariable(name: "alfred_workflow_uid", value: "AlfredKat")
    }
    
    private static func mockAlfredWorkflowCacheFolder() {
        var folder = URL(string: #file)!
        folder.deleteLastPathComponent()
        
        guard let alfredWorkflowUID = ProcessInfo.processInfo.environment["alfred_workflow_uid"] else { return XCTFail() }

        Self.setEnvironmentVariable(name: "alfred_workflow_cache", value: folder.path + "/Resources/Caches/\(alfredWorkflowUID)")
    }
    
    private static func removeAlreadyCreatedUpdateInfoFile() throws {
        let updateAvailableFile = try XCTUnwrap(Self.updateAvailableFile)
        
        if FileManager.default.fileExists(atPath: updateAvailableFile) {
            guard let _ = try? FileManager.default.removeItem(atPath: updateAvailableFile) else { return XCTFail() }
        }
    }
    
}
