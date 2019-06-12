using xml

@Js
internal class TestText : HtmlParserTest {
	
	XElem?		elem
	
	Void testRawText() {
		// plain text
		elem := parser.parseDoc("<script> Dude! </script>")
		verifyElemEq(elem, "<script> Dude! </script>")

		// no comments
		elem = parser.parseDoc("<script><!-- comment --></script>")
		verifyElemEq(elem, "<script>&lt;!-- comment --></script>")
		verifyEq(elem.text.val, "<!-- comment -->")

		// no char refs
		elem = parser.parseDoc("<script>wot &#160;&#xA0;&nbsp; ever</script>")
		verifyElemEq(elem, "<script>wot &amp;#160;&amp;#xA0;&amp;nbsp; ever</script>")
		verifyEq(elem.text.val, "wot &#160;&#xA0;&nbsp; ever")

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
//		afPegger::Parser#.pod.log.level = LogLevel.debug
		elem = parser.parseDoc("<textarea><!-- comment --></textarea>")
		verifyElemEq(elem, "<textarea>&lt;!-- comment --></textarea>")
		verifyEq(elem.text.val, "<!-- comment -->")

		// char refs
		elem = parser.parseDoc("<textarea>wot &#160;&#xA0;&nbsp; ever</textarea>")
		verifyElemEq(elem, "<textarea>wot &#160;&#xA0;&#160; ever</textarea>")
		verifyEq(elem.text.val, "wot \u00A0\u00A0\u00A0 ever")

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
		elem = parser.parseDoc("<div>wot &#160;&#xA0;&nbsp; ever</div>")
		verifyElemEq(elem, "<div>wot &#160;&#xA0;&#160; ever</div>")
		verifyEq(elem.text.val, "wot \u00A0\u00A0\u00A0 ever")

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
