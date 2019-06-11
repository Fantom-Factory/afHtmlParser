using afPegger

class HtmlGrammar : Test {
	
	Grammar grammar() {
		grammar := `fan://afHtmlParser/res/html.peg.txt`.toFile.readAllStr
		return Peg.parseGrammar(grammar)
	}
	
	Void testG() {
		HtmlGrammar().grammar		
	}
	
	static Void main(Str[] args) {
		HtmlGrammar().grammar
	}
}
