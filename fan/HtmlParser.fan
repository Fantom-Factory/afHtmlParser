using afPegger
using xml::XElem
using concurrent::Actor

** Parses HTML strings into XML documents.
@Js
class HtmlParser {
	
	** Parses the given HTML string into an XML document.
	XElem parseDoc(Str html) {
		peg		:= Peg(html, grammar["html"])
		match	:= peg.match
		
		match.dump
		
		walker	:= HtmlWalker()
		walker.walk(match)
		return walker.document.root
	}

	
	Grammar grammar() {
		grammar := `fan://afHtmlParser/res/html.peg.txt`.toFile.readAllStr
		return Peg.parseGrammar(grammar)
	}
	
	
	
	private Log log			:= HtmlParser#.pod.log 
	** Parses the given HTML string into an XML document.
	XElem parseDocOld(Str html) {
		startTime := Duration.now
		peg := Peg(html, HtmlRules().rootRule)
		
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
