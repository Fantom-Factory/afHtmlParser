using xml

@Js
internal class TestRefs : HtmlParserTest {
	
	HtmlParser	parser := HtmlParser()
	XElem?		elem
	
	Void testRefs() {
		// namedCharRef
		elem = parser.parseDoc("<html> &nbsp; </html>")
		verifyEq(elem.text.val, " \u00A0 ")
		
		// decNumCharRef
		elem = parser.parseDoc("<html> &#32; </html>")
		verifyEq(elem.text.val, " \u0020 ")
		
		// hexNumCharRef
		elem = parser.parseDoc("<html> &#x20; </html>")
		verifyEq(elem.text.val, " \u0020 ")
		
		// borkedRef
		elem = parser.parseDoc("<html> emma & steve </html>")
		verifyEq(elem.text.val, " emma & steve ")
	}
}
