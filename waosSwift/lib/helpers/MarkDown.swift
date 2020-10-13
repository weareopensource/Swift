import Down

/**
 * @desc generateWebPage from markdown
 * @param {String} _markdown
 * @param {Bool} links, display or not
 * @return {String} to path to webview
 */
func generateWebPage(_ markdown: String, links: Bool = true, head: Bool = false) -> String {

    struct Metric {
        static let background = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
    }

    let down = Down(markdownString: markdown)
    let htmlString = (try? down.toHTML()) ?? ""
    let style = """
        @media print{*,:after,:before{background:0 0!important;color:#000!important;box-shadow:none!important;text-shadow:none!important}a,a:visited{text-decoration:underline}a[href]:after{content:" (" attr(href) ")"}abbr[title]:after{content:" (" attr(title) ")"}a[href^="#"]:after,a[href^="javascript:"]:after{content:""}blockquote,pre{border:1px solid #999;page-break-inside:avoid}thead{display:table-header-group}img,tr{page-break-inside:avoid}img{max-width:100%!important}h2,h3,p{orphans:3;widows:3}h2,h3{page-break-after:avoid}}html{font-size:12px}@media screen and (min-width:32rem) and (max-width:48rem){html{font-size:15px}}@media screen and (min-width:48rem){html{font-size:16px}}body{line-height:1.85}.air-p,p{font-size:1rem;margin-bottom:1.3rem}.air-h1,.air-h2,.air-h3,.air-h4,h1,h2,h3,h4{margin:1.414rem 0 .5rem;font-weight:inherit;line-height:1.42}.air-h1,h1{margin-top:0;font-size:2.298rem}.air-h2,h2{font-size:1.827rem}.air-h3,h3{font-size:1.599rem}.air-h4,h4{font-size:1.214rem}.air-h5,h5{font-size:1rem}.air-h6,h6{font-size:.88rem}.air-small,small{font-size:.707em}canvas,iframe,img,select,svg,textarea,video{max-width:100%}body{color:#444;font-family:'Open Sans',Helvetica,sans-serif;font-weight:300;margin:6rem auto 1rem;max-width:48rem;text-align:center}img{border-radius:50%;height:200px;margin:0 auto;width:200px}a,a:visited{color:#3498db}a:active,a:focus,a:hover{color:#2980b9}pre{background-color:#fafafa;padding:1rem;text-align:left}blockquote{margin:0;border-left:5px solid #7a7a7a;font-style:italic;padding:1.33em;text-align:left}li,ol,ul{text-align:left}p{color:#777}
        """

    var output = """
        <html>
            <head>
                <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
                <style>\(style)</style>
            </head>
            <body style=\"margin-top:\(head ? "75" : "0")px;background:#\(Metric.background?.toHex() ?? "");\">\(htmlString)</body>
        </html>
    """
    if(!links) {
        output = output
            .replacingOccurrences(of: "<a.*?</a>", with: "", options: [.regularExpression])
            .replacingOccurrences(of: "\\(\\)", with: "", options: [.regularExpression])
    }
    return output
}
