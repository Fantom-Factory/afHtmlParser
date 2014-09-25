using xml
using afPegger
using concurrent

class HtmlParser {
	private Rule htmlRules := HtmlRules().rootRule
	
	XDoc parseDocument(Str html) {		
		parser := Parser(htmlRules)
		
		// TODO: parse multiple root elements, combine into 1 xml doc
		ctx := ParseCtx()

		Actor.locals["afHtmlParser.ctx"] = ctx
		res := parser.parse(html.in)
		Actor.locals.remove("afHtmlParser.ctx")
		
		if (res == null)
			throw ParseErr("Could not parse HTML: \n${html.toCode(null)}")
		
		return ctx.document
	}

	XElem parseFragment(Str html, XElem? context) {
		// see 8.4
		XElem("dude")
	}

}
