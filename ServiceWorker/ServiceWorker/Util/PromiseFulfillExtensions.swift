import Foundation
import PromiseKit

/// This is messy, but our Objective-C functions that we want to call on separate threads
/// often need to resolve promises. But we can't return anything from these functions
/// (NSObject.perform() is always a void) so instead we need to pass through fulfill and
/// reject as function parameters. So we use this as a container for those functions.
@objc class PromisePassthrough: NSObject {

    let fulfill: (Any?) -> Void
    let reject: (Error) -> Void

    init(fulfill: @escaping (Any?) -> Void, reject: @escaping (Error) -> Void) {
        self.fulfill = fulfill
        self.reject = reject
    }
}

extension Promise {

    /// And an extension method on Promise to create a passthrough promise
    static func makePassthrough() -> (promise: Promise<T>, passthrough: PromisePassthrough) {

        let (promise, seal) = Promise<T>.pending()

        let fulfillCast = { (result: Any?) in

            if T.self == Void.self, let voidResult = () as? T {
                seal.fulfill(voidResult)
                return
            }

            guard let cast = result as? T else {
                seal.reject(ErrorMessage("Could not cast \(result ?? "nil") to desired type \(T.self)"))
                return
            }
            seal.fulfill(cast)
        }

        let passthrough = PromisePassthrough(fulfill: fulfillCast, reject: seal.reject)

        return (promise, passthrough)
    }

    /// And to turn any already-created promise into a passthrough.
    func passthrough(_ target: PromisePassthrough) {
        self.done { result in
            target.fulfill(result)
        }
        .catch { error in
            target.reject(error)
        }
    }
}
