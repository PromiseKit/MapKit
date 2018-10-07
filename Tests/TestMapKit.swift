import PromiseKit
import PMKMapKit
import MapKit
import XCTest

class Test_MKDirections_Swift: XCTestCase {
    func test_directions_response() {
        let ex = expectation(description: "")

        class MockDirections: MKDirections {
            override func calculate(completionHandler: @escaping MKDirectionsHandler) {
                completionHandler(MKDirectionsResponse(), nil)
            }
        }

        let rq = MKDirectionsRequest()
        let directions = MockDirections(request: rq)

        directions.calculate().done { _ in
            ex.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }


    func test_ETA_response() {
        let ex = expectation(description: "")

        class MockDirections: MKDirections {
            override func calculateETA(completionHandler: @escaping MKETAHandler) {
                completionHandler(MKETAResponse(), nil)
            }
        }

        let rq = MKDirectionsRequest()
        MockDirections(request: rq).calculateETA().done { rsp in
            ex.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

}

class Test_MKSnapshotter_Swift: XCTestCase {
    func test() {
        let ex = expectation(description: "")

        class MockSnapshotter: MKMapSnapshotter {
            override func start(completionHandler: @escaping MKMapSnapshotCompletionHandler) {
                completionHandler(MKMapSnapshot(), nil)
            }
        }

        let snapshotter = MockSnapshotter()
        snapshotter.start().done { _ in
            ex.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}

//////////////////////////////////////////////////////////// Cancellation

extension Test_MKDirections_Swift {
    func test_cancel_directions_response() {
        let ex = expectation(description: "")

        class MockDirections: MKDirections {
            override func calculate(completionHandler: @escaping MKDirectionsHandler) {
                completionHandler(MKDirectionsResponse(), nil)
            }
        }

        let rq = MKDirectionsRequest()
        let directions = MockDirections(request: rq)

        directions.cancellableCalculate().done { _ in
            XCTFail()
        }.catch(policy: .allErrors) {
            $0.isCancelled ? ex.fulfill() : XCTFail()
        }.cancel()

        waitForExpectations(timeout: 1, handler: nil)
    }


    func test_cancel_ETA_response() {
        let ex = expectation(description: "")

        class MockDirections: MKDirections {
            override func calculateETA(completionHandler: @escaping MKETAHandler) {
                completionHandler(MKETAResponse(), nil)
            }
        }

        let rq = MKDirectionsRequest()
        MockDirections(request: rq).cancellableCalculateETA().done { _ in
            XCTFail()
        }.catch(policy: .allErrors) {
            $0.isCancelled ? ex.fulfill() : XCTFail()
        }.cancel()

        waitForExpectations(timeout: 1, handler: nil)
    }

}

extension Test_MKSnapshotter_Swift {
    func test_cancel() {
        let ex = expectation(description: "")

        class MockSnapshotter: MKMapSnapshotter {
            override func start(completionHandler: @escaping MKMapSnapshotCompletionHandler) {
                completionHandler(MKMapSnapshot(), nil)
            }
        }

        let snapshotter = MockSnapshotter()
        snapshotter.cancellableStart().done { _ in
            XCTFail()
        }.catch(policy: .allErrors) {
            $0.isCancelled ? ex.fulfill() : XCTFail()
        }.cancel()

        waitForExpectations(timeout: 1, handler: nil)
    }
}
