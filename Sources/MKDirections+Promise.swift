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
    public func calculate() -> Promise<Response> {
        return Promise<Response>(cancellableTask: MKDirectionsTask(self)) { calculate(completionHandler: $0.resolve) }
    }

    /// Begins calculating the requested travel-time information asynchronously.
    public func calculateETA() -> Promise<ETAResponse> {
        return Promise<ETAResponse>(cancellableTask: MKDirectionsTask(self)) { calculateETA(completionHandler: $0.resolve) }
    }
#else
    /// Begins calculating the requested route information asynchronously.
    public func calculate() -> Promise<MKDirectionsResponse> {
        return Promise<MKDirectionsResponse>(cancellableTask: MKDirectionsTask(self)) { calculate(completionHandler: $0.resolve) }
    }

    /// Begins calculating the requested travel-time information asynchronously.
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

//////////////////////////////////////////////////////////// Cancellable wrappers

extension MKDirections {
#if swift(>=4.2)
    /// Begins calculating the requested route information asynchronously.
    public func cancellableCalculate() -> CancellablePromise<Response> {
        return cancellable(calculate())
    }

    /// Begins calculating the requested travel-time information asynchronously.
    public func cancellableCalculateETA() -> CancellablePromise<ETAResponse> {
        return cancellable(calculateETA())
    }
#else
    /// Begins calculating the requested route information asynchronously.
    public func cancellableCalculate() -> CancellablePromise<MKDirectionsResponse> {
        return cancellable(calculate())
    }

    /// Begins calculating the requested travel-time information asynchronously.
    public func cancellableCalculateETA() -> CancellablePromise<MKETAResponse> {
        return cancellable(calculateETA())
    }
#endif
}