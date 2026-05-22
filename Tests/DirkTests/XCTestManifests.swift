import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DirkTests.allTests),
        testCase(ResolveTests.allTests),
    ]
}
#endif
