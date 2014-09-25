using xml

internal class TestAttributes : HtmlParserTest {
	
	XElem?		elem
	HtmlParser 	parser := HtmlParser()
	
	Void testEmptyAttributes() {
		elem := parser.parseDocument("<div empty></div>").root
		verifyElemEq(elem, "<div empty='empty' />")

		// whitespace problems...
		elem = parser.parseDocument("<div empty ></div>").root
		verifyElemEq(elem, "<div empty='empty' />")

		// slash / problems...
		elem = parser.parseDocument("<div empty />").root
		verifyElemEq(elem, "<div empty='empty' />")

		// technically this is invalid HTML, but it's easier to allow it!
		elem = parser.parseDocument("<div empty/>").root
		verifyElemEq(elem, "<div empty='empty' />")
	}

	Void testUnquotedAttributes() {
		elem = parser.parseDocument("<div type=submit></div>").root
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDocument("<div type  =  submit />").root
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDocument("<div type=sub&#160;mit></div>").root
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")
	}

	Void testSingleQuotedAttributes() {
		elem = parser.parseDocument("<div type='submit'></div>").root
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDocument("<div type  =  'submit' />").root
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDocument("<div type='sub&#160;mit'></div>").root
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")
	}

	Void testDoubleQuotedAttributes() {
		elem = parser.parseDocument("<div type=\"submit\"></div>").root
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDocument("<div type  =  \"submit\" />").root
		verifyElemEq(elem, "<div type='submit' />")

		elem = parser.parseDocument("<div type  =  \"sub&#160;mit\" />").root
		verifyElemEq(elem, "<div type='sub\u00A0mit' />")
	}

	Void testMixedAttributes() {
		elem := parser.parseDocument("<div attr1 attr2=unquoted attr3='single' attr4=\"double\" />").root
		verifyElemEq(elem, "<div attr1='attr1' attr2='unquoted' attr3='single' attr4='double' />")
	}
}
