using xml

** http://www.w3.org/html/wg/drafts/html/CR/syntax.html
internal class TestTags : HtmlParserTest {
	
	HtmlParser parser := HtmlParser()

	Void testValidSimpleTag() {
		elem := parser.parseDocument("<html></html>").root
		verifyEq(elem.name, "html")
		verifyEq(elem.attrs.size, 0)
		verifyEq(elem.children.size, 0)

		elem = parser.parseDocument("<html  ></html>").root
		verifyEq(elem.name, "html")
		verifyEq(elem.attrs.size, 0)
		verifyEq(elem.children.size, 0)

		elem = parser.parseDocument("<html/>").root
		verifyEq(elem.name, "html")
		verifyEq(elem.attrs.size, 0)
		verifyEq(elem.children.size, 0)

		elem = parser.parseDocument("<html  />").root
		verifyEq(elem.name, "html")
		verifyEq(elem.attrs.size, 0)
		verifyEq(elem.children.size, 0)
	}

	Void testValidNestedTag() {
		elem := parser.parseDocument("<html><head></head></html>").root
		verifyElemEq(elem, "<html><head/></html>")
		
		elem = parser.parseDocument("<html><head  ></head></html>").root
		verifyElemEq(elem, "<html><head/></html>")
		
		elem = parser.parseDocument("<html><head/></html>").root
		verifyElemEq(elem, "<html><head/></html>")
		
		elem = parser.parseDocument("<html><head  /></html>").root
		verifyElemEq(elem, "<html><head/></html>")
	}

	Void testValidSiblingTags() {
		elem := parser.parseDocument("<html><head/><body/></html>").root
		verifyElemEq(elem, "<html><head/><body/></html>")
		
		elem = parser.parseDocument("<html><head><title/></head></html>").root
		verifyElemEq(elem, "<html><head><title/></head></html>")
		
		elem = parser.parseDocument("<html><head/><body><div/></body></html>").root
		verifyElemEq(elem, "<html><head/><body><div/></body></html>")
	}

	Void testVoidTags() {
		elem := parser.parseDocument("<area>").root
		verifyElemEq(elem, "<area/>")
		
		elem = parser.parseDocument("<html><meta  ><img  ></html>").root
		verifyElemEq(elem, "<html><meta/><img/></html>")
	}

	Void testRawTextTags() {
		elem := parser.parseDocument("<script></script>").root
		verifyElemEq(elem, "<script/>")
		
		elem = parser.parseDocument("<style></style>").root
		verifyElemEq(elem, "<style/>")
	}

	Void testEscapableRawTextTags() {
		elem := parser.parseDocument("<textarea></textarea>").root
		verifyElemEq(elem, "<textarea/>")
	}
}
