struct Config {
    /**
     * @desc global var for default configuration, development / production
     */
    lazy var global: JSON = {
        // init development config
        let pathDev = Bundle.main.path(forResource: "development", ofType: "json")!
        let jsonStringDev = try? String(contentsOfFile: pathDev, encoding: String.Encoding.utf8)
        var result = JSON(parseJSON: jsonStringDev!)
        if let configuration = Bundle.main.infoDictionary?["Configuration"] as? String {
            if configuration.range(of: "development") != nil {
                return result
            }
        }
        // merge with production config if needed
        let pathProd = Bundle.main.path(forResource: "production", ofType: "json")!
        do {
            let jsonStringProd = try? String(contentsOfFile: pathProd, encoding: String.Encoding.utf8)
            try result.merge(with: JSON(parseJSON: jsonStringProd!))
            result = try result.merged(with: JSON(parseJSON: jsonStringProd!))
        } catch {
            log.error(error)
        }
        return result
    }()
}

var config = Config()
