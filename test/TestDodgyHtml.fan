using xml

** http://www.w3.org/html/wg/drafts/html/CR/syntax.html
@Js
internal class TestDodgyHtml : HtmlParserTest {

	// https://www.w3.org/TR/html/grouping-content.html#the-p-element
	// A p element’s end tag may be omitted 
	Void testNonClosingPTags() {
		
		elem := parser.parseDoc("<div><p>text1<p>text2</div>")
		verifyElemEq(elem, "<div><p>text1</p><p>text2</p></div>")
	}
	
	// https://www.w3.org/TR/html/tabular-data.html#the-tr-element
	// A tr element’s end tag may be omitted if the tr element is immediately followed by another tr element, or if there is no more content in the parent element.
	Void testNonClosingTrTags() {
		
		elem := parser.parseDoc("<table><tr><td>data1</td><tr><td>data2</td></table>")
		verifyElemEq(elem, "<table><tr><td>data1</td></tr><tr><td>data2</td></tr></table>")
	}

	// https://www.w3.org/TR/html-markup/td.html#td-tags
	// A td element’s end tag may be omitted if the td element is immediately followed by a td or th element, or if there is no more content in the parent element.
	Void testNonClosingTdTags() {
		
		elem := parser.parseDoc("<table><tr><td>data1<td>data2</tr></table>")
		verifyElemEq(elem, "<table><tr><td>data1</td><td>data2</td></tr></table>")

		// TWO non-closing tags!
		// yeah - this fails!
		elem = parser.parseDoc("<div><table><tr><td>data1<td>data2</table></div>")
		verifyElemEq(elem, "<div><table><tr><td>data1</td><td>data2</td></tr></table></div>")
	}

	Void testUnbalancedTags() {
		verifyErrMsg(ParseErr#, "End tag </body> does not match start tag <div>") {
			parser.parseDoc("<body><div>data1</body>")
		}

		verifyErrMsg(ParseErr#, "End tag </body> does not match start tag <section>") {
			parser.parseDoc("<body><div>data1</div><section>boo<div>data1</div></body>")
		}
	}
}
