using afPegger

class HtmlGrammar : Test {
	
	Grammar grammar() {
		grammar := `fan://afHtmlParser/res/html.peg.txt`.toFile.readAllStr
		return Peg.parseGrammar(grammar)
	}
	
	Void testG() {
		HtmlGrammar().grammar.definition { echo(it) }		
	}
	
	static Void main(Str[] args) {
		HtmlGrammar().grammar
	}
}
