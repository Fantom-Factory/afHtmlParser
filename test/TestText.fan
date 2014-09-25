
internal class TestText : HtmlParserTest {
	
	HtmlParser parser := HtmlParser()
	
	Void testRawText() {
		// plain text
		elem := parser.parseDocument("<script> Dude! </script>").root
		verifyElemEq(elem, "<script> Dude! </script>")

		// no comments
		elem = parser.parseDocument("<script><!-- comment --></script>").root
		verifyElemEq(elem, "<script>&lt;!-- comment --></script>")
		verifyEq(elem.text.val, "<!-- comment -->")

		// no char refs
		elem = parser.parseDocument("<script>&#160;&#xA0;</script>").root
		verifyElemEq(elem, "<script>&amp;#160;&amp;#xA0;</script>")
		verifyEq(elem.text.val, "&#160;&#xA0;")

		// no cdata
		elem = parser.parseDocument("<script><![CDATA[ nope ]]></script>").root
		verifyElemEq(elem, "<script>&lt;![CDATA[ nope ]]></script>")
		verifyEq(elem.text.val, "<![CDATA[ nope ]]>")

		// no elements
		elem = parser.parseDocument("<script><wot></wot></script>").root
		verifyElemEq(elem, "<script>&lt;wot>&lt;/wot></script>")
		verifyEq(elem.text.val, "<wot></wot>")
	}
	
	Void testEscapableRawText() {
		// plain text
		elem := parser.parseDocument("<textarea> Dude! </textarea>").root
		verifyElemEq(elem, "<textarea> Dude! </textarea>")

		// no comments
		elem = parser.parseDocument("<textarea><!-- comment --></textarea>").root
		verifyElemEq(elem, "<textarea>&lt;!-- comment --></textarea>")
		verifyEq(elem.text.val, "<!-- comment -->")

		// char refs
		elem = parser.parseDocument("<textarea>&#160;&#xA0;</textarea>").root
		verifyElemEq(elem, "<textarea>&#160;&#xA0;</textarea>")
		verifyEq(elem.text.val, "\u00A0\u00A0")

		// no cdata
		elem = parser.parseDocument("<textarea><![CDATA[ nope ]]></textarea>").root
		verifyElemEq(elem, "<textarea>&lt;![CDATA[ nope ]]></textarea>")
		verifyEq(elem.text.val, "<![CDATA[ nope ]]>")

		// no elements
		elem = parser.parseDocument("<textarea><wot></wot></textarea>").root
		verifyElemEq(elem, "<textarea>&lt;wot>&lt;/wot></textarea>")
		verifyEq(elem.text.val, "<wot></wot>")
	}
	
	Void testNormalText() {
		// plain text
		elem := parser.parseDocument("<div> Dude! </div>").root
		verifyElemEq(elem, "<div> Dude! </div>")

		// comments
		elem = parser.parseDocument("<div><!-- comment --></div>").root
		verifyElemEq(elem, "<div><!-- comment --></div>")
		verifyNull(elem.text)

		// char refs
		elem = parser.parseDocument("<div>&#160;&#xA0;</div>").root
		verifyElemEq(elem, "<div>&#160;&#xA0;</div>")
		verifyEq(elem.text.val, "\u00A0\u00A0")

		// cdata
		elem = parser.parseDocument("<div><![CDATA[ yep ]]></div>").root
		verifyElemEq(elem, "<div><![CDATA[ yep ]]></div>")
		verifyEq(elem.text.val, " yep ")
		verifyEq(elem.text.cdata, true)

		// elements
		elem = parser.parseDocument("<div><wot></wot></div>").root
		verifyElemEq(elem, "<div><wot/></div>")
	}
}
