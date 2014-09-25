using xml

internal class TestDoctype : HtmlParserTest {
	
	XDocType?	docType
	HtmlParser 	parser := HtmlParser()
	
	Void testStandardDoctype() {
		docType = parser.parseDocument("<div />").docType
		verifyEq(docType, null)

		docType = parser.parseDocument("<!DOCTYPE hTmL> <html/>").docType
		verifyEq(docType.rootElem, "hTmL")
		verifyEq(docType.publicId, null)
		verifyEq(docType.systemId, null)

		docType = parser.parseDocument("<!DOCTYPE html SYSTEM \"about:legacy-compat\"> <html/>").docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, null)
		verifyEq(docType.systemId, `about:legacy-compat`)

		docType = parser.parseDocument("<!DOCTYPE html SYSTEM 'about:legacy-compat'> <html/>").docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, null)
		verifyEq(docType.systemId, `about:legacy-compat`)

		docType = parser.parseDocument("<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.0//EN'> <html/>").docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, "-//W3C//DTD HTML 4.0//EN")
		verifyEq(docType.systemId, null)

		docType = parser.parseDocument("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' SYSTEM 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'> <html/>").docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, "-//W3C//DTD XHTML 1.0 Strict//EN")
		verifyEq(docType.systemId, `http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd`)
	}
}
