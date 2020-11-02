import Down

enum markDownStyles: String {
    case air = """
        @media print{.air *,.air :after,.air :before{background:0 0!important;color:#000!important;box-shadow:none!important;text-shadow:none!important}.air a,.air a:visited{text-decoration:underline}.air a[href]:after{content:" (" attr(href) ")"}.air abbr[title]:after{content:" (" attr(title) ")"}.air a[href^="#"]:after,.air a[href^="javascript:"]:after{content:""}.air blockquote,.air pre{border:1px solid #999;page-break-inside:avoid}.air thead{display:table-header-group}.air img,.air tr{page-break-inside:avoid}.air img{max-width:100%!important}.air h2,.air h3,.air p{orphans:3;widows:3}.air h2,.air h3{page-break-after:avoid}}.air{font-size:12px}@media screen and (min-width:32rem) and (max-width:48rem){.air{font-size:15px}}@media screen and (min-width:48rem){.air{font-size:16px}}.air{line-height:1.85}.air .air-p,.air p{font-size:1rem;margin-bottom:1.3rem}.air .air-h1,.air .air-h2,.air .air-h3,.air .air-h4,.air h1,.air h2,.air h3,.air h4{margin:1.414rem 0 .5rem;font-weight:700;line-height:1.42}.air .air-h1,.air h1{margin-top:0;font-size:200%}.air .air-h2,.air h2{font-size:180%}.air .air-h3,.air h3{font-size:160%}.air .air-h4,.air h4{font-size:140%}.air .air-h5,.air h5{font-size:120%}.air .air-h6,.air h6{font-size:100%}.air .air-small,.air small{font-size:.707em}.air canvas,.air iframe,.air img,.air select,.air svg,.air textarea,.air video{max-width:100%}.air{color:#444;font-family:'Open Sans',Helvetica,sans-serif;font-weight:300;margin:2rem auto 1rem;max-width:48rem;text-align:center}.air img{border-radius:50%;height:250px;margin:5px auto;width:250px}.air a,.air a:visited{color:#3498db}.air a:active,.air a:focus,.air a:hover{color:#2980b9}.air pre{background-color:#fafafa;padding:1rem;text-align:left}.air blockquote{margin:0;border-left:5px solid #7a7a7a;font-style:italic;padding:1.33em;text-align:left}.air li,.air ol,.air ul{text-align:left}.air p{color:#777}@media (prefers-color-scheme:dark){.air p{color:#ccc}.air{color:#eee}}
        """
}

/**
 * @desc generateWebPage from markdown
 * @param {String} _markdown
 * @param {Bool} links, display or not
 * @return {String} to path to webview
 */
func generateWebPage(_ markdown: String, style: markDownStyles = .air, links: Bool = true, head: Bool = false) -> String {
    
    struct Metric {
        static let background = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
    }
    
    let down = Down(markdownString: markdown)
    let htmlString = (try? down.toHTML()) ?? ""
    var output = """
        <html>
            <head>
                <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
                <style>\(style.rawValue)</style>
            </head>
            <body style=\"margin-top:\(head ? "75" : "0")px;background:#\(Metric.background?.toHex() ?? "");\" class="\(style)">\(htmlString)</body>
        </html>
    """
    if(!links) {
        output = output
            .replacingOccurrences(of: "<a.*?</a>", with: "", options: [.regularExpression])
            .replacingOccurrences(of: "\\(\\)", with: "", options: [.regularExpression])
    }
    return output
}
