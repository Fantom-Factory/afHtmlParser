using afPegger
using concurrent::Actor
using xml

@Js
internal class HtmlRules : Rules {

	Rule rootRule() {
		rules := Grammar()

		html							:= rules["html"]
		bom								:= rules["bom"]
		xmlProlog						:= rules["xmlProlog"]

		element 						:= rules["element"]

		voidElement						:= rules["voidElement"]
		voidElementName					:= rules["voidElementName"]

		selfClosingElement				:= rules["selfClosingElement"]

		rawTextElement					:= rules["rawTextElement"]
		rawTextElementTag				:= rules["rawTextElementTag"]
		rawTextElementName				:= rules["rawTextElementName"]
		rawTextElementContent			:= rules["rawTextElementContent"]
		rawText							:= rules["rawText"]

		escapableRawTextElement			:= rules["escapableRawTextElement"]
		escapableRawTextElementTag		:= rules["escapableRawTextElementTag"]
		escapableRawTextElementName		:= rules["escapableRawTextElementName"]
		escapableRawTextElementContent	:= rules["escapableRawTextElementContent"]
		escapableRawText				:= rules["escapableRawText"]

		normalElement					:= rules["normalElement"]
		normalElementContent			:= rules["normalElementContent"]
		normalElementText				:= rules["normalElementText"]
		startTag						:= rules["startTag"]
		endTag							:= rules["endTag"]
		tagName							:= rules["tagName"]
		
		attributes						:= rules["attributes"]
		emptyAttribute					:= rules["emptyAttribute"]
		unquotedAttribute				:= rules["unquotedAttribute"]
		singleAttribute					:= rules["singleAttribute"]
		doubleAttribute					:= rules["doubleAttribute"]
		attributeName					:= rules["attributeName"]
		
		characterReference				:= rules["characterReference"]
		decNumCharRef					:= rules["decNumCharRef"]
		hexNumCharRef					:= rules["hexNumCharRef"]
		namedCharRef					:= rules["namedCharRef"]
		borkedRef						:= rules["borkedRef"]
		
		cdata							:= rules["cdata"]
		
		comment							:= rules["comment"]

		doctype							:= rules["doctype"]
		doctypePublicId					:= rules["doctypePublicId"]
		doctypeSystemId					:= rules["doctypeSystemId"]

		whitespace						:= zeroOrMore(spaceChar)
		blurb							:= rules["blurb"] 

		rules["html"]							= sequence([optional(bom), zeroOrMore(blurb), optional(doctype), optional(xmlProlog), zeroOrMore(blurb), element, zeroOrMore(blurb)])
		rules["bom"]							= str("\uFEFF")
		rules["xmlProlog"]						= sequence([str("<?xml"), strNot("?>") ,str("?>")])
		
		rules["element"]						= firstOf([voidElement, rawTextElement, escapableRawTextElement, selfClosingElement, normalElement])

		rules["voidElement"]					= sequence([char('<'), voidElementName, attributes, char('>')])
		rules["rawTextElement"]					= sequence([rawTextElementTag, rawTextElementContent, endTag])
		rules["escapableRawTextElement"]		= sequence([escapableRawTextElementTag, escapableRawTextElementContent, endTag])
		rules["selfClosingElement"]				= sequence([char('<'), tagName, attributes, str("/>")])
		rules["normalElement"]					= sequence([startTag, optional(normalElementContent), endTag])

		rules["rawTextElementTag"]				= sequence([char('<'), rawTextElementName, attributes, char('>')])
		rules["escapableRawTextElementTag"]		= sequence([char('<'), escapableRawTextElementName, attributes, char('>')])

		rules["startTag"]						= sequence([char('<'), tagName, attributes, char('>')])
		rules["endTag"]							= sequence([str("</"), tagName, char('>')])

		rules["tagName"]						= sequence([sequence([alphaChar, zeroOrMore(charNotOf("\t\n\f />".chars))]), zeroOrMore(spaceChar)]) 

		rules["voidElementName"]				= sequence { firstOf("area base br col embed hr img input keygen link meta param source track wbr"	.split.map { str(it) }), zeroOrMore(spaceChar), }
		rules["rawTextElementName"]				= sequence { firstOf("script style"																	.split.map { str(it) }), zeroOrMore(spaceChar), }
		rules["escapableRawTextElementName"]	= sequence { firstOf("textarea title"																.split.map { str(it) }), zeroOrMore(spaceChar), }

		rules["rawTextElementContent"]			= oneOrMore(sequence([onlyIfNot(firstOf("script style"  .split.map { str("</${it}>") })), anyChar]))
		rules["escapableRawTextElementContent"]	= zeroOrMore(firstOf([escapableRawText, characterReference]))
		rules["normalElementContent"]			= sequence([onlyIfNot(str("</")), zeroOrMore(firstOf([normalElementText, characterReference, comment, cdata, element]))])
		
		rules["rawText"]						= oneOrMore(sequence([onlyIfNot(firstOf("script style"  .split.map { str("</${it}>") })), anyChar]))
		rules["escapableRawText"]				= oneOrMore(sequence([onlyIfNot(firstOf("textarea title".split.map { str("</${it}>") }.add(char('&')))), anyChar]))
		rules["normalElementText"]				= oneOrMore(charNotOf("<&".chars))
		
		unquotedAttributeVal					:= rules["unquotedAttributeVal"]
		singleAttributeVal						:= rules["singleAttributeVal"]
		doubleAttributeVal						:= rules["doubleAttributeVal"]
		
		rules["attributes"]						= zeroOrMore(sequence([onlyIf(charNotOf("/>".chars)), firstOf([spaceChar, doubleAttribute, singleAttribute, unquotedAttribute, emptyAttribute])]))
		rules["emptyAttribute"]					= sequence{attributeName,}
		rules["unquotedAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace,				unquotedAttributeVal, ])
		rules["singleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('\''),	singleAttributeVal, char('\'')])
		rules["doubleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('"' ),	doubleAttributeVal, char('"' )])
		rules["attributeName"]					= oneOrMore(charNotOf(" \t\n\r\f\"'>/=".chars))

		rules["unquotedAttributeVal"]			= oneOrMore (firstOf([charNotOf(" \t\n\r\f\"'=<>`&".chars), characterReference]))
		rules["singleAttributeVal"]				= zeroOrMore(firstOf([charNotOf(               "'&".chars), characterReference]))
		rules["doubleAttributeVal"]				= zeroOrMore(firstOf([charNotOf(              "\"&".chars), characterReference]))
		
		rules["characterReference"]				= sequence([onlyIf(char('&')), firstOf([decNumCharRef, hexNumCharRef, namedCharRef, borkedRef])])		
		rules["namedCharRef"]					= sequence([char('&'), oneOrMore(charNotOf(";>".chars)), char(';')])
		rules["decNumCharRef"]					= sequence([str("&#"), oneOrMore(numChar), char(';')])
		rules["hexNumCharRef"]					= sequence([str("&#x"), oneOrMore(hexChar), char(';')])		
		rules["borkedRef"]						= sequence([char('&'), onlyIf(spaceChar)])		

		rules["cdata"]							= sequence([str("<![CDATA["), strNot("]]>"), str("]]>")])

		rules["comment"]						= sequence([str("<!--"), strNot("--"), str("-->")])

		doctypeContent							:= rules["doctypeContent"]
		rules["doctype"]						= sequence([str("<!DOCTYPE"), oneOrMore(spaceChar), doctypeContent, zeroOrMore(firstOf([doctypePublicId, doctypeSystemId])), whitespace, str(">")])
		rules["doctypeContent"]					= oneOrMore(alphaNumChar)
		rules["doctypePublicId"]				= sequence([oneOrMore(spaceChar), str("PUBLIC"), oneOrMore(spaceChar), firstOf([sequence([char('"'), zeroOrMore(charNot('"')), char('"')]), sequence([char('\''), zeroOrMore(charNot('\'')), char('\'')])])])
		rules["doctypeSystemId"]				= sequence([oneOrMore(spaceChar), optional(sequence([str("SYSTEM"), oneOrMore(spaceChar)])), firstOf([sequence([char('"'), zeroOrMore(charNot('"')).withName("systemId1"), char('"')]), sequence([char('\''), zeroOrMore(charNot('\'')).withName("systemId2"), char('\'')])])])
		
		rules["blurb"]							= firstOf([oneOrMore(spaceChar), comment])

		echo
		echo
		echo(rules.definition)
		echo
		echo
		
		return html
	}
	
	static Void main(Str[] args) {
		HtmlRules().rootRule
	}
	
	SuccessCtx c() { Actor.locals["afHtmlParser.ctx"] }
}


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
			case "tagName"						: pushTagName(m.matched)
			case "voidElementName"				: pushTagName(m.matched)
			case "rawTextElementName"			: pushTagName(m.matched)
			case "escapableRawTextElementName"	: pushTagName(m.matched)
			case "rawTextElementContent"		: pushText(m.matched)
			case "rawText"						: pushText(m.matched)
			case "escapableRawText"				: pushText(m.matched)
			case "normalElementText"			: pushText(m.matched)

//			case "unquotedAttribute"			: pushAttr
//			case "attributeName"				: pushAttrName(m.matched)
//			case "unquotedAttributeVal"			: pushAttrVal(m.matched)
//			case "singleAttributeVal"			: pushAttrVal(m.matched)
//			case "doubleAttributeVal"			: pushAttrVal(m.matched)
//			case "emptyAttribute"				: pushAttrName(m.matched);pushAttrVal(m.matched); pushAttr
//			case "singleAttribute"				: pushAttr
//			case "doubleAttribute"				: pushAttr

			case "emptyAttr"					: attrElem.addAttr(m["attrName"].matched, m["attrName"].matched)
			case "unquotedAttr"					:
			case "singleQuoteAttr"				:
			case "doubleQuoteAttr"				: attrElem.addAttr(m["attrName"].matched, m["attrValue"]?.matched ?: "")

			case "namedCharRef"					: pushNomCharRef(m.matched)
			case "decNumCharRef"				: pushDecCharRef(m.matched)
			case "hexNumCharRef"				: pushHexCharRef(m.matched)
			case "borkedRef"					: pushBorkedRef(m.matched)
			case "cdata"						: pushCdata(m.matched)
			
			case "doctypeName"					: pushDoctype(m.matched)
			case "publicId"						: pushPublicId(m.matched)
			case "systemId"						: pushSystemId(m.matched)
		}
	}
	
	// ---------------------------------------------------------------------------
	
	static const Log log		:= SuccessCtx#.pod.log
	XElem[]			roots		:= XElem[,]	
	XElem?			openElement
	XElem			attrElem	:= XElem("attrs")
	Str?			attrName
	Str?			attrValue
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
//		if (openElement.children.last?.nodeType == XNodeType.text)
//			// for mashing lots of char refs together
//			((XText) openElement.children.last).val += text
//		else
//			openElement.add(XText(text))
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
