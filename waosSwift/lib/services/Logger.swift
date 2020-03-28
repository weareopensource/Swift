/**
 * Dependencies
 */

import CocoaLumberjackSwift

/**
 * class
 */

private class LogFormatter: NSObject, DDLogFormatter {

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        let dateFormat = config["log"]["dateFormat"].string ?? "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    public func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = LogFormatter.dateFormatter.string(from: logMessage.timestamp)
        let level = logMessage.flag.level
        let filename = logMessage.fileName
        let function = logMessage.function ?? ""
        let line = logMessage.line
        let message = logMessage.message
        return "\(level) - \(timestamp) - \(filename):\(line) - \(function) : \(message)"
    }

    private func formattedDate(from date: Date) -> String {
        return LogFormatter.dateFormatter.string(from: date)
    }

}

let log = Logger()

final class Logger {

    init() {
        DDOSLogger.sharedInstance.logFormatter = LogFormatter()
        DDLog.add(DDOSLogger.sharedInstance)

        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    func error(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) {
        let message = self.message(from: items)
        DDLogError(message, file: file, function: function, line: line)
    }

    func warning(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) {
        let message = self.message(from: items)
        DDLogWarn(message, file: file, function: function, line: line)
    }

    func info(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) {
        let message = self.message(from: items)
        DDLogInfo(message, file: file, function: function, line: line)
    }

    func debug(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) {
        let message = self.message(from: items)
        DDLogDebug(message, file: file, function: function, line: line)
    }

    func verbose(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) {
        let message = self.message(from: items)
        DDLogVerbose(message, file: file, function: function, line: line)
    }

    private func message(from items: [Any]) -> String {
        return items
            .map { String(describing: $0) }
            .joined(separator: " ")
    }

}

/**
 * extensions
 */

extension DDLogFlag {
    public var level: String {
        switch self {
        case DDLogFlag.error: return config["log"]["message"]["error"].string ?? "ERROR"
        case DDLogFlag.warning: return config["log"]["message"]["warning"].string ?? "WARNING"
        case DDLogFlag.info: return config["log"]["message"]["info"].string ?? "INFO"
        case DDLogFlag.debug: return config["log"]["message"]["debug"].string ?? "DEBUG"
        case DDLogFlag.verbose: return config["log"]["message"]["verbose"].string ?? "VERBOSE"
        default: return config["log"]["message"]["unknown"].string ?? "UNKNOWN"
        }
    }
}
