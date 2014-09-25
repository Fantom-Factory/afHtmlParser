
internal class TestText : HtmlParserTest {
	
	HtmlParser parser := HtmlParser()
	
	Void testRawText() {
		// plain text
		elem := parser.parseDoc("<script> Dude! </script>")
		verifyElemEq(elem, "<script> Dude! </script>")

		// no comments
		elem = parser.parseDoc("<script><!-- comment --></script>")
		verifyElemEq(elem, "<script>&lt;!-- comment --></script>")
		verifyEq(elem.text.val, "<!-- comment -->")

		// no char refs
		elem = parser.parseDoc("<script>&#160;&#xA0;</script>")
		verifyElemEq(elem, "<script>&amp;#160;&amp;#xA0;</script>")
		verifyEq(elem.text.val, "&#160;&#xA0;")

		// no cdata
		elem = parser.parseDoc("<script><![CDATA[ nope ]]></script>")
		verifyElemEq(elem, "<script>&lt;![CDATA[ nope ]]></script>")
		verifyEq(elem.text.val, "<![CDATA[ nope ]]>")

		// no elements
		elem = parser.parseDoc("<script><wot></wot></script>")
		verifyElemEq(elem, "<script>&lt;wot>&lt;/wot></script>")
		verifyEq(elem.text.val, "<wot></wot>")
	}
	
	Void testEscapableRawText() {
		// plain text
		elem := parser.parseDoc("<textarea> Dude! </textarea>")
		verifyElemEq(elem, "<textarea> Dude! </textarea>")

		// no comments
		elem = parser.parseDoc("<textarea><!-- comment --></textarea>")
		verifyElemEq(elem, "<textarea>&lt;!-- comment --></textarea>")
		verifyEq(elem.text.val, "<!-- comment -->")

		// char refs
		elem = parser.parseDoc("<textarea>&#160;&#xA0;</textarea>")
		verifyElemEq(elem, "<textarea>&#160;&#xA0;</textarea>")
		verifyEq(elem.text.val, "\u00A0\u00A0")

		// no cdata
		elem = parser.parseDoc("<textarea><![CDATA[ nope ]]></textarea>")
		verifyElemEq(elem, "<textarea>&lt;![CDATA[ nope ]]></textarea>")
		verifyEq(elem.text.val, "<![CDATA[ nope ]]>")

		// no elements
		elem = parser.parseDoc("<textarea><wot></wot></textarea>")
		verifyElemEq(elem, "<textarea>&lt;wot>&lt;/wot></textarea>")
		verifyEq(elem.text.val, "<wot></wot>")
	}
	
	Void testNormalText() {
		// plain text
		elem := parser.parseDoc("<div> Dude! </div>")
		verifyElemEq(elem, "<div> Dude! </div>")

		// comments
		elem = parser.parseDoc("<div><!-- comment --></div>")
		verifyElemEq(elem, "<div><!-- comment --></div>")
		verifyNull(elem.text)

		// char refs
		elem = parser.parseDoc("<div>&#160;&#xA0;</div>")
		verifyElemEq(elem, "<div>&#160;&#xA0;</div>")
		verifyEq(elem.text.val, "\u00A0\u00A0")

		// cdata
		elem = parser.parseDoc("<div><![CDATA[ yep ]]></div>")
		verifyElemEq(elem, "<div><![CDATA[ yep ]]></div>")
		verifyEq(elem.text.val, " yep ")
		verifyEq(elem.text.cdata, true)

		// elements
		elem = parser.parseDoc("<div><wot></wot></div>")
		verifyElemEq(elem, "<div><wot/></div>")
	}
}
