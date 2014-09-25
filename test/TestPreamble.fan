using xml

internal class TestPreamble : HtmlParserTest {
	
	HtmlParser 	parser := HtmlParser()
	
	Void testPreabmle() {
		elem := parser.parseDocument("\uFEFF <!-- com --> \t <!-- com --> <!DOCTYPE wotever> <!-- com --> \t <!-- com --> <html/> <!-- com --> \t <!-- com --> ").root
		verifyElemEq(elem, "<html/>")
		verifyEq(elem.doc.docType.rootElem, "wotever")

		elem = parser.parseDocument("\uFEFF <!-- com --> \t <!-- com --> <?xml version='1.0' encoding='UTF-8'?> <!-- com --> \t <!-- com --> <html/> <!-- com --> \t <!-- com --> ").root
		verifyElemEq(elem, "<html/>")
	}
}
