/**
 * Dependencies
 */

import UIKit

/**
 * functions
 */

/**
 * @desc generate api url
 * @param {String} _protocol,
 * @param {String} _host,
 * @param {String} _port,
 * @param {String} _path,
 * @return {URL}
 */
func getUrl(_protocol: String, _host: String, _port: String, _path: String) -> URL! {
    var port = ""
    if(_port.count > 0) {
        port = ":\(_port)"
    }
    guard let url = URL(string: "\(_protocol)://\(_host)\(port)/\(_path)") else { fatalError("baseUrl could not be configured." ) }
    return url
}

/**
 * @desc generate an upload image url with options (from http://toto.png to http://toto-300-blur.png)
 * @param {String} _url,
 * @param {String} _size,
 * @param {String} _operation,
 * @return {String}
 */
func setUploadImageUrl(_ image: String, size: String? = nil, operation: String? = nil) -> String! {

    let baseUrl: String = getUrl(_protocol: config["api"]["protocol"].string ?? "http",
    _host: config["api"]["host"].string ?? "localhost",
    _port: config["api"]["port"].string ?? "3000",
    _path: config["api"]["endPoints"]["basePath"].string ?? "api").absoluteString

    let apiPathUploads = config["api"]["endPoints"]["uploads"].string ?? "uploads"

    var _image: String
    let base = image.split {$0 == "."}
    if(base.count != 2) {
        return image
    } else {
        _image = "\(base[0])"
    }
    if let _size = size {
        _image = "\(_image)-\(_size)"
    }
    if let _operation = operation {
        _image = "\(_image)-\(_operation)"
    }
    _image = "\(_image).\(base[1])"
    return baseUrl + "/" + apiPathUploads + "/images/" + _image
}
