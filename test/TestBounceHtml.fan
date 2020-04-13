using afPegger::Peg

internal class TestBounceHtml : HtmlParserTest {
	
	Void testBounce() {
		html := `test/bounce.html`.toFile.readAllStr
		doc  := parser.parseDoc(html)
		
		// just check no errors are thrown
	}
}
