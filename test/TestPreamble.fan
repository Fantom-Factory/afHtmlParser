using xml
using afPegger

@Js
internal class TestPreamble : HtmlParserTest {
	
	Void testPreabmle() {
		elem := null as XElem
		
		elem = parser.parseDoc("\uFEFF<html/>")
		verifyElemEq(elem, "<html/>")
		
		elem = parser.parseDoc("\uFEFF <!-- com --> \t <!-- com --> <!DOCTYPE wotever> <!-- com --> \t <!-- com --> <html/> <!-- com --> \t <!-- com --> ")
		verifyElemEq(elem, "<html/>")
		verifyEq(elem.doc.docType.rootElem, "wotever")

		elem = parser.parseDoc("\uFEFF <!-- com --> \t <!-- com --> <?xml version='1.0' encoding='UTF-8'?> <!-- com --> \t <!-- com --> <html/> <!-- com --> \t <!-- com --> ")
		verifyElemEq(elem, "<html/>")
	}
}
