using xml

internal class ParseCtx {
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
		attrElem.addAttr(attrName, attrValue)
		attrName = null
		attrValue = null
	}

	Void pushDecCharRef(Str text) {
		ref := text["&#".size..<-";".size].toInt(10).toChar
		if (attrName != null)
			pushAttrVal(ref)
		else
			pushText(ref)
	}
	
	Void pushHexCharRef(Str text) {
		ref := text["&#x".size..<-";".size].toInt(16).toChar
		if (attrName != null)
			pushAttrVal(ref)
		else
			pushText(ref)
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
