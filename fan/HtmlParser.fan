using afPegger::Grammar
using afPegger::Peg
using xml::XElem

** Parses HTML strings into XML documents.
@Js
class HtmlParser {
	private Grammar? _grammar
	
	** Parses the given HTML string into an XML document.
	XElem parseDoc(Str html) {
		peg		:= Peg(html, grammar["html"])
		match	:= peg.match
		
		if (match == null)
			throw ParseErr("Could not parse HTML")
		
//		match.dump
		return HtmlMatchWalker().walk(match).docRoot
	}
	
	** Returns the grammar used to parse HTML.
	Grammar grammar() {
		if (_grammar == null) {
			grammar := `fan://afHtmlParser/res/html.peg.txt`.toFile.readAllStr
			_grammar = Peg.parseGrammar(grammar)
		}
		return _grammar
	}
}
