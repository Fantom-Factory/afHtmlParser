using afPegger
using concurrent::Actor
using xml

internal class HtmlWalker {
	
	Void walk(Match match) {
		stepIn(match)
		match.matches.each { walk(it) }
		stepOut(match)
	}
	
	Void stepIn(Match m) {
		switch (m.name) {
			
		}
	}
	
	Void stepOut(Match m) {
		switch (m.name) {
			case "voidElement"					: pushVoidTag
			case "selfClosingElement"			: pushVoidTag
			case "rawTextElementTag"			: pushStartTag
			case "escapableRawTextElementTag"	: pushStartTag
			case "startTag"						: pushStartTag
			case "endTag"						: pushEndTag
			case "elementName"					: pushTagName(m.matched)
			case "voidElementName"				: pushTagName(m.matched)
			case "rawTextElementName"			: pushTagName(m.matched)
			case "escapableRawTextElementName"	: pushTagName(m.matched)

			case "rawTextElementContent"		: pushText(m.matched)
			case "tagText"						: pushText(deEscapeText(m))
			case "escapableRawTextElementContent"	: pushText(deEscapeText(m))

			case "emptyAttr"					: attrElem.addAttr(m["attrName"].matched, m["attrName"].matched)
			case "unquotedAttr"					:
			case "singleQuoteAttr"				:
			case "doubleQuoteAttr"				: attrElem.addAttr(m["attrName"].matched, deEscapeText(m["attrValue"]))

			case "cdata"						: pushCdata(m.matched)
			
			case "doctypeName"					: pushDoctype(m.matched)
			case "publicId"						: pushPublicId(m.matched)
			case "systemId"						: pushSystemId(m.matched)
		}
	}
	
	Str deEscapeText(Match? match) {
		match?.matches?.join("") |m| {
			if (m.name == "text")	return m.matched
			if (m.name == "charRef") {
				m = m.matches.first
				text := m.matched
				switch (m.name) {
					case "text"				: return text
					case "namedCharRef"		: return nomCharRef(text)
					case "decNumCharRef"	: return text["&#".size..<-1].toInt(10).toChar
					case "hexNumCharRef"	: return text["&#x".size..<-1].toInt(16).toChar
					case "borkedRef"		: return text
					default					: throw UnsupportedErr(m.name)
				}
			}
			throw UnsupportedErr(m.name)
		} ?: ""
	}
	
	Str nomCharRef(Str text) {
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
		return text
	}
	
	// ---------------------------------------------------------------------------
	
	static const Log log		:= SuccessCtx#.pod.log
	XElem[]			roots		:= XElem[,]	
	XElem?			openElement
	XElem			attrElem	:= XElem("attrs")
	Str?			tagName
	XDoc?			doc
	Bool			beLenient
	
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
		this.tagName = tagName.trimEnd
	}
	
	Void pushVoidTag() {
		pushStartTag
		tagName = openElement.name
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
		
		tagName = null
		
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

	Void pushCdata(Str text) {
		cdata := XText(text["<![CDATA[".size..<-"]]>".size])
		cdata.cdata = true
		openElement.add(cdata)
	}
	
	Void pushEndTag() {
		if (tagName != openElement.name) {
			msg := "End tag </${tagName}> does not match start tag <${openElement.name}>"
			if (beLenient) {
				log.warn(msg)
				return
			}
			throw ParseErr(msg)
		}

		if (openElement.parent?.nodeType != XNodeType.doc)
			openElement = openElement.parent
	}
	
	XDoc document() {
		// TODO: check size of roots
		doc ?: XDoc(roots.first)
	}
}
