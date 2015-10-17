using xml

internal class TestAttributes : HtmlParserTest {
	
	XElem?		elem
	HtmlParser 	parser := HtmlParser()
	
	Void testEmptyAttributes() {
		elem := parser.parseDoc("<div empty></div>")
		verifyElemEq(elem, "<div empty='empty' />")

		// whitespace problems...
		elem = parser.parseDoc("<div empty ></div>")
		verifyElemEq(elem, "<div empty='empty' />")

		// slash / problems...
		elem = parser.parseDoc("<div empty />")
		verifyElemEq(elem, "<div empty='empty' />")

		// technically this is invalid HTML, but it's easier to allow it!
		elem = parser.parseDoc("<div empty/>")
		verifyElemEq(elem, "<div empty='empty' />")
	}

	Void testUnquotedAttributes() {
		elem = parser.parseDoc("<div type=submit></div>")
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDoc("<div type  =  submit />")
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDoc("<div type=sub&#160;mit></div>")
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")

		elem = parser.parseDoc("<div type=sub&amp;mit></div>")
		verifyElemEq(elem, "<div type='sub&amp;mit' />")

		elem = parser.parseDoc("<div type=sub&nbsp;mit></div>")
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")
	}

	Void testSingleQuotedAttributes() {
		elem = parser.parseDoc("<div type='submit'></div>")
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDoc("<div class=''></div>")
		verifyElemEq(elem, "<div class='' />")

		elem = parser.parseDoc("<div type  =  'submit' />")
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDoc("<div type='sub&#160;mit'></div>")
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")

		elem = parser.parseDoc("<div type='sub&amp;mit'></div>")
		verifyElemEq(elem, "<div type='sub&amp;mit' />")

		elem = parser.parseDoc("<div type='sub&nbsp;mit'></div>")
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")
	}

	Void testDoubleQuotedAttributes() {
		elem = parser.parseDoc("<div type=\"submit\"></div>")
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDoc("<div class=\"\"></div>")
		verifyElemEq(elem, "<div class='' />")

		elem = parser.parseDoc("<div type  =  \"submit\" />")
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDoc("<div type  =  \"sub&#160;mit\" />")
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")

		elem = parser.parseDoc("<div type=\"sub&amp;mit\"></div>")
		verifyElemEq(elem, "<div type='sub&amp;mit' />")

		elem = parser.parseDoc("<div type=\"sub&nbsp;mit\"></div>")
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")
	}

	Void testMixedAttributes() {
		elem := parser.parseDoc("<div attr1 attr2=unquoted attr3='single' attr4=\"double\" />")
		verifyElemEq(elem, "<div attr1='attr1' attr2='unquoted' attr3='single' attr4='double' />")
	}
}
