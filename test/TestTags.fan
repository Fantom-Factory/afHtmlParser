using xml

** http://www.w3.org/html/wg/drafts/html/CR/syntax.html
@Js
internal class TestTags : HtmlParserTest {
	
	Void testValidSimpleTag() {
		elem := parser.parseDoc("<html></html>")
		verifyEq(elem.name, "html")
		verifyEq(elem.attrs.size, 0)
		verifyEq(elem.children.size, 0)

		elem = parser.parseDoc("<html  ></html>")
		verifyEq(elem.name, "html")
		verifyEq(elem.attrs.size, 0)
		verifyEq(elem.children.size, 0)

		elem = parser.parseDoc("<html/>")
		verifyEq(elem.name, "html")
		verifyEq(elem.attrs.size, 0)
		verifyEq(elem.children.size, 0)

		elem = parser.parseDoc("<html  />")
		verifyEq(elem.name, "html")
		verifyEq(elem.attrs.size, 0)
		verifyEq(elem.children.size, 0)
	}

	Void testValidNestedTag() {
		elem := parser.parseDoc("<html><head></head></html>")
		verifyElemEq(elem, "<html><head/></html>")
		
		elem = parser.parseDoc("<html><head  ></head></html>")
		verifyElemEq(elem, "<html><head/></html>")

		elem = parser.parseDoc("<html><head/></html>")
		verifyElemEq(elem, "<html><head/></html>")
		
		elem = parser.parseDoc("<html><head  /></html>")
		verifyElemEq(elem, "<html><head/></html>")
	}

	Void testValidSiblingTags() {
		elem := parser.parseDoc("<html><head/><body/></html>")
		verifyElemEq(elem, "<html><head/><body/></html>")
		
		elem = parser.parseDoc("<html><head><title/></head></html>")
		verifyElemEq(elem, "<html><head><title/></head></html>")
		
		elem = parser.parseDoc("<html><head/><body><div/></body></html>")
		verifyElemEq(elem, "<html><head/><body><div/></body></html>")
	}

	Void testVoidTags() {
		elem := parser.parseDoc("<area>")
		verifyElemEq(elem, "<area/>")
		
		elem = parser.parseDoc("<html><meta  ><img  ></html>")
		verifyElemEq(elem, "<html><meta/><img/></html>")
		
		elem = parser.parseDoc("<html><meta a=b ><img src='test'  ></html>")
		verifyElemEq(elem, "<html><meta a='b'/><img src='test'/></html>")
	}

	Void testRawTextTags() {
		elem := parser.parseDoc("<script></script>")
		verifyElemEq(elem, "<script/>")
		
		elem = parser.parseDoc("<style></style>")
		verifyElemEq(elem, "<style/>")
	}

	Void testEscapableRawTextTags() {
		elem := parser.parseDoc("<textarea></textarea>")
		verifyElemEq(elem, "<textarea/>")
	}
}
