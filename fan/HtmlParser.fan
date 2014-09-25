using xml
using afPegger
using concurrent

** Parses HTML strings into XML documents.
class HtmlParser {
	private Rule htmlRules := HtmlRules().rootRule
	
	** Parses the given HTML string into an XML document.
	XElem parseDoc(Str html) {		
		parser := Parser(htmlRules)
		
		ctx := ParseCtx()

		Actor.locals["afHtmlParser.ctx"] = ctx
		res := parser.parse(html.in)
		Actor.locals.remove("afHtmlParser.ctx")
		
		if (res == null)
			throw ParseErr("Could not parse HTML: \n${html.toCode(null)}")
		
		return ctx.document.root
	}

	// TODO: parse multiple root elements
//	XElem[] parseFrag(Str html) {
//		// see 8.4
//	}
}
