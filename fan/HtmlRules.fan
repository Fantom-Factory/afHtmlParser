using afPegger
using concurrent::Actor

@Js
internal class HtmlRules : Rules {
	
	Rule rootRule() {
		rules := Grammar()

		preamble						:= rules["preamble"]
		bom								:= rules["bom"]
		xml								:= rules["xml"]

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
		blurb							:= zeroOrMore(firstOf([oneOrMore(spaceChar), comment]))

		rules["preamble"]						= sequence([bom, blurb, optional(doctype), xml, blurb, element, blurb])
		rules["bom"]							= optional(str("\uFEFF"))
		rules["xml"]							= optional(sequence([str("<?xml"), strNot("?>") ,str("?>")]))
		
		rules["element"]						= firstOf([voidElement, rawTextElement, escapableRawTextElement, selfClosingElement, normalElement])

		rules["voidElement"]					= sequence([char('<'), voidElementName, attributes, char('>')])				.withAction |s| { c.pushVoidTag }
		rules["rawTextElement"]					= sequence([rawTextElementTag, rawTextElementContent, endTag])
		rules["escapableRawTextElement"]		= sequence([escapableRawTextElementTag, escapableRawTextElementContent, endTag])
		rules["selfClosingElement"]				= sequence([char('<'), tagName, attributes, str("/>")])						.withAction |s| { c.pushVoidTag }
		rules["normalElement"]					= sequence([startTag, optional(normalElementContent), endTag])

		rules["rawTextElementTag"]				= sequence([char('<'), rawTextElementName, attributes, char('>')])			.withAction |s| { c.pushStartTag }
		rules["escapableRawTextElementTag"]		= sequence([char('<'), escapableRawTextElementName, attributes, char('>')])	.withAction |s| { c.pushStartTag }

		rules["startTag"]						= sequence([char('<'), tagName, attributes, char('>')])						.withAction |s| { c.pushStartTag }
		rules["endTag"]							= sequence([str("</"), tagName, char('>')])									.withAction |s| { c.pushEndTag }

		rules["tagName"]						= tagNameRule(sequence([alphaChar, zeroOrMore(charNotOf("\t\n\f />".chars))]))

		rules["voidElementName"]				= firstOf("area base br col embed hr img input keygen link meta param source track wbr"	.split.map { tagNameRule(str(it)) })
		rules["rawTextElementName"]				= firstOf("script style"																.split.map { tagNameRule(str(it)) })
		rules["escapableRawTextElementName"]	= firstOf("textarea title"																.split.map { tagNameRule(str(it)) })

		rules["rawTextElementContent"]			= rawText
		rules["escapableRawTextElementContent"]	= zeroOrMore(firstOf([escapableRawText, characterReference]))
		rules["normalElementContent"]			= sequence([onlyIfNot(str("</")), zeroOrMore(firstOf([normalElementText, characterReference, comment, cdata, element]))])
		
		rules["rawText"]						= oneOrMore(sequence([onlyIfNot(firstOf("script style"  .split.map { str("</${it}>") })), anyChar]))				.withAction |s| { c.pushText(s) }
		rules["escapableRawText"]				= oneOrMore(sequence([onlyIfNot(firstOf("textarea title".split.map { str("</${it}>") }.add(char('&')))), anyChar]))	.withAction |s| { c.pushText(s) }
		rules["normalElementText"]				= oneOrMore(charNotOf("<&".chars))																					.withAction |s| { c.pushText(s) }
		
		rules["attributes"]						= zeroOrMore(sequence([onlyIf(charNotOf("/>".chars)), firstOf([spaceChar, doubleAttribute, singleAttribute, unquotedAttribute, emptyAttribute])]))
		rules["emptyAttribute"]					= nTimes(1, attributeName).withAction |s| { c.pushAttrVal(c.attrName); c.pushAttr }	// can't put the action on attributeName
		rules["unquotedAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace,			   oneOrMore(firstOf([charNotOf(" \t\n\r\f\"'=<>`&".chars)	.withAction |s| { c.pushAttrVal(s) }, characterReference])).withAction |s| { c.pushAttr } ])
		rules["singleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('\''), zeroOrMore(firstOf([charNotOf(	 	      "'&".chars)	.withAction |s| { c.pushAttrVal(s) }, characterReference])).withAction |s| { c.pushAttr }, char('\'')])
		rules["doubleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('"'),  zeroOrMore(firstOf([charNotOf(	 	     "\"&".chars)	.withAction |s| { c.pushAttrVal(s) }, characterReference])).withAction |s| { c.pushAttr }, char('"')])
		rules["attributeName"]					= oneOrMore(charNotOf(" \t\n\r\f\"'>/=".chars)) 																					.withAction |s| { c.pushAttrName(s) }
		
		rules["characterReference"]				= sequence([onlyIf(char('&')), firstOf([decNumCharRef, hexNumCharRef, namedCharRef, borkedRef])])		
		rules["namedCharRef"]					= sequence([char('&'), oneOrMore(charNotOf(";>".chars)), char(';')]).withAction |s| { c.pushNomCharRef(s) }
		rules["decNumCharRef"]					= sequence([str("&#"), oneOrMore(numChar), char(';')])				.withAction |s| { c.pushDecCharRef(s) }
		rules["hexNumCharRef"]					= sequence([str("&#x"), oneOrMore(hexChar), char(';')])				.withAction |s| { c.pushHexCharRef(s) }		
		rules["borkedRef"]						= sequence([char('&'), onlyIf(spaceChar)])							.withAction |s| { c.pushBorkedRef (s) }		

		rules["cdata"]							= sequence([str("<![CDATA["), strNot("]]>"), str("]]>")]).withAction |s| { c.pushCdata(s) }

		rules["comment"]						= sequence([str("<!--"), strNot("--"), str("-->")])

		rules["doctype"]						= sequence([str("<!DOCTYPE"), oneOrMore(spaceChar), oneOrMore(alphaNumChar).withAction |s| { c.pushDoctype(s) }, zeroOrMore(firstOf([doctypePublicId, doctypeSystemId])), whitespace, str(">")])
		rules["doctypePublicId"]				= sequence([oneOrMore(spaceChar), str("PUBLIC"), oneOrMore(spaceChar), firstOf([sequence([char('"'), zeroOrMore(charNot('"')).withAction |s| { c.pushPublicId(s) }, char('"')]), sequence([char('\''), zeroOrMore(charNot('\'')).withAction |s| { c.pushPublicId(s) }, char('\'')])])])
		rules["doctypeSystemId"]				= sequence([oneOrMore(spaceChar), optional(sequence([str("SYSTEM"), oneOrMore(spaceChar)])), firstOf([sequence([char('"'), zeroOrMore(charNot('"')).withAction |s| { c.pushSystemId(s) }, char('"')]), sequence([char('\''), zeroOrMore(charNot('\'')).withAction |s| { c.pushSystemId(s) }, char('\'')])])])
		
		return preamble
	}
	
	Rule tagNameRule(Rule rule) {
		sequence([rule.withAction |s| { c.pushTagName(s) }, zeroOrMore(spaceChar)])
	}
	
	SuccessCtx c() { Actor.locals["afHtmlParser.ctx"] }
}

