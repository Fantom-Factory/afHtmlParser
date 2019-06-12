using afPegger::Match
using xml::XDoc
using xml::XDocType
using xml::XNodeType
using xml::XElem
using xml::XText

@Js
internal class HtmlMatchWalker {	
	private static const Log	log		:= HtmlParser#.pod.log
	private XDoc?				doc
	private XElem?				elem
	private Bool				beLenient

	XElem docRoot() {
		// ensure there's a XDoc attached to the root 
		(doc ?: XDoc(elem)).root
	}

	This walk(Match match) {
		go(match)
		return this
	}
	
	private Void go(Match match) {
		stepIn(match)
		match.matches.each { go(it) }
		stepOut(match)
	}
	
	private Void stepIn(Match m) {
		switch (m.name) {
			case "doctypeElem"			: doctype (m.matched)
			case "publicId"				: publicId(m.matched)
			case "systemId"				: systemId(m.matched)

			case "startTag"				: startTag(m.matched)
			case "endTag"				: endTag  (m.matched)
			case "voidTag"				: startTag(m.matched)

			case "tagText"				: addText(deEscapeText(m))
			case "rawTextContent"		: addText(m.matched)
			case "escRawTextContent"	: addText(deEscapeText(m))

			case "emptyAttr"			: elem.addAttr(m["attrName"].matched, m["attrName"].matched)
			case "attr"					: elem.addAttr(m["attrName"].matched, deEscapeText(m["attrValue"]))

			case "cdata"				: cdata(m.matched)
		}
	}
	
	private Void stepOut(Match m) {
		switch (m.name) {
			case "voidTag"				: endTag(m.matched)
		}
	}
	
	private Void doctype(Str name) {
		doc = XDoc()
		doc.docType = XDocType()
		doc.docType.rootElem = name
	}

	private Void systemId(Str id) {
		doc.docType.systemId = id.toUri
	}
	
	private Void publicId(Str id) {
		doc.docType.publicId = id
	}
	
	private Void startTag(Str tagName) {
		if (elem == null) {
			elem = XElem(tagName)
			if (doc != null)
				doc.root = elem
		} else {
			elem := XElem(tagName)
			this.elem.add(elem)
			this.elem = elem
		}
	}
	
	private Void endTag(Str tagName) {
		if (tagName != elem.name) {
			msg := "End tag </${tagName}> does not match start tag <${elem.name}>"
			if (beLenient)
				 { log.warn(msg); return }
			throw ParseErr(msg)
		}

		if (elem.parent?.nodeType == XNodeType.elem)
			elem = elem.parent
	}

	private Str deEscapeText(Match? match) {
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
	
	private Str nomCharRef(Str text) {
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
	
	private Void addText(Str text) {
		if (elem.children.last?.nodeType == XNodeType.text)
			// for mashing lots of char refs together
			((XText) elem.children.last).val += text
		else
			elem.add(XText(text))
	}

	private Void cdata(Str text) {
		cdata := XText(text["<![CDATA[".size..<-"]]>".size])
		cdata.cdata = true
		elem.add(cdata)
	}
}
