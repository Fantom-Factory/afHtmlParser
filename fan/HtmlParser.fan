using afPegger
using xml::XElem
using concurrent::Actor

** Parses HTML strings into XML documents.
@Js
class HtmlParser {
	private Log log			:= HtmlParser#.pod.log 
	private Rule htmlRules	:= HtmlRules().rootRule
	
	** Parses the given HTML string into an XML document.
	XElem parseDoc(Str html) {
//	XElem parseDoc(Str html, [Str:Obj]? options := null) {
		startTime := Duration.now
		peg := Peg(html, htmlRules)
		
//		beLenient := options?.get("lenient") == true
//		sctx  := SuccessCtx() { it.beLenient = beLenient }
		sctx  := SuccessCtx()
		Actor.locals["afHtmlParser.ctx"] = sctx
		match := peg.match
		
		if (log.isDebug) {
			millis := (Duration.now - startTime).toMillis.toLocale("#,000")		
			log.debug("HTML parsed in ${millis}ms")
		}
		
		if (match == null)
			throw ParseErr("Could not parse HTML: \n${html.toCode(null)}")
		
		return sctx.document.root
	}

	// TODO: parse multiple root elements
//	XElem[] parseFrag(Str html) {
//		// see 8.4
//	}
}
