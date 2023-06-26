import AlfredBrookCore
import Foundation


Workflow.setURLCache()

print(
    Workflow.next() == "do"
        ? Workflow.notify(resultFrom: Workflow.do())
        : Workflow.menu()
)
