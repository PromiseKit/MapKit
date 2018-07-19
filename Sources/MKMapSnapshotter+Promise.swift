import MapKit
#if !PMKCocoaPods
import PMKCancel
import PromiseKit
#endif

/**
 To import the `MKMapSnapshotter` category:

    use_frameworks!
    pod "PromiseKit/MapKit"

 And then in your sources:

    import PromiseKit
*/
extension MKMapSnapshotter {
    /// Starts generating the snapshot using the options set in this object.
    public func start() -> Promise<MKMapSnapshot> {
        return Promise { start(completionHandler: $0.resolve) }
    }
}

//////////////////////////////////////////////////////////// Cancellation

fileprivate class MKMapSnapshotterTask: CancellableTask {
    let snapshotter: MKMapSnapshotter
    var cancelAttempted = false
    
    init(_ snapshotter: MKMapSnapshotter) {
        self.snapshotter = snapshotter
    }
    
    func cancel() {
        snapshotter.cancel()
        cancelAttempted = true
    }
    
    var isCancelled: Bool {
        return cancelAttempted && !snapshotter.isLoading
    }
}

extension MKMapSnapshotter {
    /// Starts generating the snapshot using the options set in this object.
    public func startCC() -> CancellablePromise<MKMapSnapshot> {
        return CancellablePromise(task: MKMapSnapshotterTask(self)) { start(completionHandler: $0.resolve) }
    }
}
