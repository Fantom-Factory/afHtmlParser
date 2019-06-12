using afPegger
using xml::XElem

** Parses HTML strings into XML documents.
@Js
class HtmlParser {
	
	** Parses the given HTML string into an XML document.
	XElem parseDoc(Str html) {
		peg		:= Peg(html, grammar["html"])
		match	:= peg.match
		
//		match.dump
		
		walker	:= HtmlWalker()
		walker.walk(match)
		return walker.document.root
	}

	
	Grammar grammar() {
		grammar := `fan://afHtmlParser/res/html.peg.txt`.toFile.readAllStr
		return Peg.parseGrammar(grammar)
	}


	// TODO: parse multiple root elements
//	XElem[] parseFrag(Str html) {
//		// see 8.4
//	}
}
