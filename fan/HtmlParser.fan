using xml
using afPegger

** Parses HTML strings into XML documents.
@Js
class HtmlParser {
	private Log log			:= HtmlParser#.pod.log 
	private Rule htmlRules	:= HtmlRules().rootRule
	
	** Parses the given HTML string into an XML document.
	XElem parseDoc(Str html) {
		startTime := Duration.now
		parser := Parser(htmlRules)
		
		sctx := SuccessCtx()
		matched := parser.matches(html.in, sctx)
		
		if (log.isDebug) {
			millis := (Duration.now - startTime).toMillis.toLocale("#,000")		
			log.debug("HTML parsed in ${millis}ms")
		}
		
		if (!matched)
			throw ParseErr("Could not parse HTML: \n${html.toCode(null)}")
		
		return sctx.document.root
	}

	// TODO: parse multiple root elements
//	XElem[] parseFrag(Str html) {
//		// see 8.4
//	}
}
