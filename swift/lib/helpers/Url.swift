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
