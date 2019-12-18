import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FreryCountDownButtonPackageTests.allTests),
    ]
}
#endif
