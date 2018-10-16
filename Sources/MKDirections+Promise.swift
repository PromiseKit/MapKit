import MapKit
#if !PMKCocoaPods
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
#if swift(>=4.2)
    /// Begins calculating the requested route information asynchronously.
    /// - Note: cancelling this promise will cancel the underlying task
    /// - SeeAlso: [Cancellation](http://promisekit.org/docs/)
    public func calculate() -> Promise<Response> {
        return Promise<Response>(cancellableTask: MKDirectionsTask(self)) { calculate(completionHandler: $0.resolve) }
    }

    /// Begins calculating the requested travel-time information asynchronously.
    /// - Note: cancelling this promise will cancel the underlying task
    /// - SeeAlso: [Cancellation](http://promisekit.org/docs/)
    public func calculateETA() -> Promise<ETAResponse> {
        return Promise<ETAResponse>(cancellableTask: MKDirectionsTask(self)) { calculateETA(completionHandler: $0.resolve) }
    }
#else
    /// Begins calculating the requested route information asynchronously.
    /// - Note: cancelling this promise will cancel the underlying task
    /// - SeeAlso: [Cancellation](http://promisekit.org/docs/)
    public func calculate() -> Promise<MKDirectionsResponse> {
        return Promise<MKDirectionsResponse>(cancellableTask: MKDirectionsTask(self)) { calculate(completionHandler: $0.resolve) }
    }

    /// Begins calculating the requested travel-time information asynchronously.
    /// - Note: cancelling this promise will cancel the underlying task
    /// - SeeAlso: [Cancellation](http://promisekit.org/docs/)
    public func calculateETA() -> Promise<MKETAResponse> {
        return Promise<MKETAResponse>(cancellableTask: MKDirectionsTask(self)) { calculateETA(completionHandler: $0.resolve) }
    }
#endif
}

private class MKDirectionsTask: CancellableTask {
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
