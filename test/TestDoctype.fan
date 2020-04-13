using xml

@Js
internal class TestDoctype : HtmlParserTest {
	
	XDocType?	docType
	
	Void testStandardDoctype() {
		docType = parser.parseDoc("<div />").doc.docType
		verifyEq(docType, null)

		docType = parser.parseDoc("<!DOCTYPE html>\n<html></html>").doc.docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, null)
		verifyEq(docType.systemId, null)

		docType = parser.parseDoc("<!DOCTYPE hTmL> <html/>").doc.docType
		verifyEq(docType.rootElem, "hTmL")
		verifyEq(docType.publicId, null)
		verifyEq(docType.systemId, null)

		docType = parser.parseDoc("<!DOCTYPE html SYSTEM \"about:legacy-compat\"> <html/>").doc.docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, null)
		verifyEq(docType.systemId, `about:legacy-compat`)

		docType = parser.parseDoc("<!DOCTYPE html SYSTEM 'about:legacy-compat'> <html/>").doc.docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, null)
		verifyEq(docType.systemId, `about:legacy-compat`)

		docType = parser.parseDoc("<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.0//EN'> <html/>").doc.docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, "-//W3C//DTD HTML 4.0//EN")
		verifyEq(docType.systemId, null)

		docType = parser.parseDoc("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' SYSTEM 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'> <html/>").doc.docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, "-//W3C//DTD XHTML 1.0 Strict//EN")
		verifyEq(docType.systemId, `http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd`)

		docType = parser.parseDoc("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html/>").doc.docType
		verifyEq(docType.rootElem, "html")
		verifyEq(docType.publicId, "-//W3C//DTD XHTML 1.0 Transitional//EN")
		verifyEq(docType.systemId, `http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd`)
	}
}
