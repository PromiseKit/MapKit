import MapKit
#if !PMKCocoaPods
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
#if swift(>=4.2)
    /// Starts generating the snapshot using the options set in this object.
    public func start() -> Promise<Snapshot> {
        return Promise<Snapshot>(cancellableTask: MKMapSnapshotterTask(self)) { start(completionHandler: $0.resolve) }
    }
#else
    /// Starts generating the snapshot using the options set in this object.
    public func start() -> Promise<MKMapSnapshot> {
        return Promise<MKMapSnapshot>(cancellableTask: MKMapSnapshotterTask(self)) { start(completionHandler: $0.resolve) }
    }
#endif
}

private class MKMapSnapshotterTask: CancellableTask {
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

//////////////////////////////////////////////////////////// Cancellable wrapper

extension MKMapSnapshotter {
#if swift(>=4.2)
    /// Starts generating the snapshot using the options set in this object.
    public func cancellableStart() -> CancellablePromise<Snapshot> {
        return cancellable(start())
    }
#else
    /// Starts generating the snapshot using the options set in this object.
    public func cancellableStart() -> CancellablePromise<MKMapSnapshot> {
        return cancellable(start())
    }
#endif
}