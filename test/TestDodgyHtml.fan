using xml

** http://www.w3.org/html/wg/drafts/html/CR/syntax.html
@Js
internal class TestDodgyHtml : HtmlParserTest {
	
	// https://www.w3.org/TR/html-markup/tr.html#tr-tags
	// A tr element’s end tag may be omitted if the tr element is immediately followed by another tr element, or if there is no more content in the parent element.
	Void testNonClosingTrTags() {
		
		// yeah - this fails!
		
		elem := parser.parseDoc("<table><tr><td>data1</td><tr><td>data2</td></table>")
		verifyElemEq(elem, "<table><tr><td>data1</td></tr><tr><td>data2</td></tr></table>")
	}

	// https://www.w3.org/TR/html-markup/td.html#td-tags
	// A td element’s end tag may be omitted if the td element is immediately followed by a td or th element, or if there is no more content in the parent element.
	Void testNonClosingTdTags() {
		
		// yeah - this fails!

		elem := parser.parseDoc("<table><tr><td>data1<td>data2</table>")
		verifyElemEq(elem, "<table><tr><td>data1</td><td>data2</td></tr></table>")
	}
}
