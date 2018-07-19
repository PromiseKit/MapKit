import MapKit
#if !PMKCocoaPods
import PMKCancel
import PromiseKit
#endif

/**
 To import the `MKDirections` category:

    use_frameworks!
    pod "PromiseKit/MapKit"

 And then in your sources:

    import PromiseKit
*/
extension MKDirections {
    /// Begins calculating the requested route information asynchronously.
    public func calculate() -> Promise<MKDirectionsResponse> {
        return Promise { calculate(completionHandler: $0.resolve) }
    }

    /// Begins calculating the requested travel-time information asynchronously.
    public func calculateETA() -> Promise<MKETAResponse> {
        return Promise { calculateETA(completionHandler: $0.resolve) }
    }
}

//////////////////////////////////////////////////////////// Cancellation

fileprivate class MKDirectionsTask: CancellableTask {
    let directions: MKDirections
    var cancelAttempted = false
    
    init(_ directions: MKDirections) {
        self.directions = directions
    }
    
    func cancel() {
        directions.cancel()
        cancelAttempted = true
    }
    
    var isCancelled: Bool {
        return cancelAttempted && !directions.isCalculating
    }
}

extension MKDirections {
    /// Begins calculating the requested route information asynchronously.
    public func calculateCC() -> CancellablePromise<MKDirectionsResponse> {
        return CancellablePromise(task: MKDirectionsTask(self)) { calculate(completionHandler: $0.resolve) }
    }

    /// Begins calculating the requested travel-time information asynchronously.
    public func calculateETACC() -> CancellablePromise<MKETAResponse> {
        return CancellablePromise(task: MKDirectionsTask(self)) { calculateETA(completionHandler: $0.resolve) }
    }
}
