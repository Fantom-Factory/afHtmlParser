using xml
using afPegger
using concurrent

** Parses HTML strings into XML documents.
class HtmlParser {
	private Log log			:= HtmlParser#.pod.log 
	private Rule htmlRules	:= HtmlRules().rootRule
	
	** Parses the given HTML string into an XML document.
	XElem parseDoc(Str html) {
		startTime := Duration.now
		parser := Parser(htmlRules)
		
		sctx := SuccessCtx()
		Actor.locals["afHtmlParser.successCtx"] = sctx
//		Actor.locals["afHtmlParser.parseCtx"]	= ParseCtx()
		res := parser.parse(html.in)
		Actor.locals.remove("afHtmlParser.successCtx")
//		Actor.locals.remove("afHtmlParser.parseCtx")
		
		if (log.isDebug) {
			millis := (Duration.now - startTime).toMillis.toLocale("#,000")		
			log.debug("HTML parsed in ${millis}ms")
		}
		
		if (res == null)
			throw ParseErr("Could not parse HTML: \n${html.toCode(null)}")
		
		return sctx.document.root
	}

	// TODO: parse multiple root elements
//	XElem[] parseFrag(Str html) {
//		// see 8.4
//	}
}
