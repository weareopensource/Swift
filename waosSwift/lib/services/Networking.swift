/**
 * Dependencies
 */

import Moya
import RxMoya
import UIKit

/**
 * class
 */

final class Networking<Target: TargetType>: MoyaProvider<Target> {
    init(plugins: [PluginType] = []) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10

        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        super.init(manager: manager, plugins: plugins)
    }

    func request(
        _ target: Target,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) -> Single<Response> {
        let requestString = "\(target.method) \(target.path)"

        return self.rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "🌎 success -> \(requestString) (\(value.statusCode))"
                    log.debug(message, file: file, function: function, line: line)
            },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        // .mapJson()
                        if let jsonObject = try? response.mapString() {
                            let message = "🌎 failure -> \(requestString) (\(response.statusCode)) : \(jsonObject) (\(target))"
                            log.warning(message, file: file, function: function, line: line)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "🌎 failure -> \(requestString) (\(response.statusCode)) : \(rawString) (\(target))"
                            log.warning(message, file: file, function: function, line: line)
                        } else {
                            let message = "🌎 failure -> \(requestString) (\(response.statusCode)) (\(target))"
                            log.warning(message, file: file, function: function, line: line)
                        }
                    } else {
                        let message = "🌎 failure -> \(requestString)\n\(error)"
                        log.warning(message, file: file, function: function, line: line)
                    }
            },
                onSubscribed: {
                    let message = "🌎 request -> \(requestString)"
                    log.debug(message, file: file, function: function, line: line)
            }
        )
    }
}
