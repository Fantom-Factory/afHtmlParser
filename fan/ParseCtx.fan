using xml

//internal class ParseCtx {
//	Str[] tagStack	:= Str[,]
//}

@Js
internal class SuccessCtx {
	XElem[]			roots		:= XElem[,]	
	XElem?			openElement
	XElem			attrElem	:= XElem("attrs")
	Str?			attrName
	Str?			attrValue
	Str?			tagName
	XDoc?			doc
	
	Void pushDoctype(Str name) {
		doc = XDoc()
		doc.docType = XDocType()
		doc.docType.rootElem = name
	}

	Void pushSystemId(Str id) {
		doc.docType.systemId = id.toUri
	}
	
	Void pushPublicId(Str id) {
		doc.docType.publicId = id
	}
	
	Void pushTagName(Str tagName) {
		this.tagName = tagName.trim
	}
	
	Void pushVoidTag() {
		pushStartTag
		&tagName = openElement.name
		pushEndTag
	}

	Void pushStartTag() {
		if (openElement == null) {
			openElement = XElem(tagName)
			roots.add(openElement)
			if (doc != null)
				doc.root = openElement
		} else {
			elem := XElem(tagName)
			openElement.add(elem)
			openElement = elem
		}
		
		&tagName = null
		
		attrElem.attrs.each { openElement.add(it) }
		attrElem = XElem("attrs")
	}

	Void pushText(Str text) {
		if (openElement.children.last?.nodeType == XNodeType.text)
			// for mashing lots of char refs together
			((XText) openElement.children.last).val += text
		else
			openElement.add(XText(text))
	}

	Void pushAttrName(Str name) {
		attrName = name
	}

	Void pushAttrVal(Str val) {
		attrValue = (attrValue ?: Str.defVal) + val
	}
	
	Void pushAttr() {
		attrElem.addAttr(attrName, attrValue ?: Str.defVal)
		attrName = null
		attrValue = null
	}

	Void pushNomCharRef(Str text) {
		// decode XML entities 
		// leave HTML entities as they are 'cos XML don't understand them
		if (text.equalsIgnoreCase("&lt;"))		text = "<"
		if (text.equalsIgnoreCase("&gt;"))		text = ">"
		if (text.equalsIgnoreCase("&amp;"))		text = "&"
		if (text.equalsIgnoreCase("&apos;"))	text = "'"
		if (text.equalsIgnoreCase("&quot;"))	text = "\""

		// unmatched entities will throw an Unsupported Entity Err, 
		// so lets be nice and decode some common cases
		if (text.equalsIgnoreCase("&nbsp;"))	text = "\u00A0"
		
		// TODO: decode ALL entities as detailed at:
		// http://www.w3.org/html/wg/drafts/html/CR/entities.json
		// That's all 2332 of them!
		
		if (attrName != null)
			pushAttrVal(text)
		else
			pushText(text)
	}

	Void pushDecCharRef(Str text) {
		ref := text["&#".size..<-1].toInt(10).toChar
		if (attrName != null)
			pushAttrVal(ref)
		else
			pushText(ref)
	}
	
	Void pushHexCharRef(Str text) {
		ref := text["&#x".size..<-1].toInt(16).toChar
		if (attrName != null)
			pushAttrVal(ref)
		else
			pushText(ref)
	}

	Void pushBorkedRef(Str text) {
		if (attrName != null)
			pushAttrVal(text)
		else
			pushText(text)
	}

	Void pushCdata(Str text) {
		cdata := XText(text["<![CDATA[".size..<-"]]>".size])
		cdata.cdata = true
		openElement.add(cdata)
	}
	
	Void pushEndTag() {
		if (tagName != openElement.name)
			throw ParseErr("End tag </${tagName}> does not match start tag <${openElement.name}>")

		if (openElement.parent?.nodeType != XNodeType.doc)
			openElement = openElement.parent
	}
	
	XDoc document() {
		// TODO: check size of roots
		doc ?: XDoc(roots.first)
	}
}
