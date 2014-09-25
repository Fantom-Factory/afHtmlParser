using afPegger
using concurrent

internal class HtmlRules : Rules {
	
	Rule rootRule() {
		rules := NamedRules()

		preamble						:= rules["preamble"]
		blurb							:= rules["blurb"]
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
		
		cdata							:= rules["cdata"]
		
		comment							:= rules["comment"]

		doctype							:= rules["doctype"]
		doctypeSystemId					:= rules["doctypeSystemId"]
		doctypePublicId					:= rules["doctypePublicId"]

		whitespace						:= rules["whitespace"]

		rules["preamble"]						= sequence([bom, blurb, optional(doctype), xml, blurb, element, blurb])
		rules["blurb"]							= zeroOrMore(firstOf([oneOrMore(anySpaceChar), comment]))
		rules["bom"]							= optional(str("\uFEFF"))
		rules["xml"]							= optional(sequence([str("<?xml"), strNot("?>") ,str("?>")]))
		
		rules["element"]						= firstOf([voidElement, rawTextElement, escapableRawTextElement, normalElement, selfClosingElement])

		rules["voidElement"]					= sequence([char('<'), voidElementName, attributes,  char('>')])					.withAction { ctx.pushVoidTag }
		rules["rawTextElement"]					= sequence([rawTextElementTag, rawTextElementContent, endTag])
		rules["escapableRawTextElement"]		= sequence([escapableRawTextElementTag, escapableRawTextElementContent, endTag])
		rules["selfClosingElement"]				= sequence([char('<'), tagName, attributes, str("/>")])								.withAction { ctx.pushVoidTag }
		rules["normalElement"]					= sequence([startTag, normalElementContent, endTag])

		rules["rawTextElementTag"]				= sequence([char('<'), rawTextElementName, attributes, char('>')])					.withAction { ctx.pushStartTag }
		rules["escapableRawTextElementTag"]		= sequence([char('<'), escapableRawTextElementName, attributes, char('>')])			.withAction { ctx.pushStartTag }

		rules["startTag"]						= sequence([char('<'), tagName, attributes, char('>')])								.withAction { ctx.pushStartTag }
		rules["endTag"]							= sequence([str("</"), tagName, char('>')])											.withAction { ctx.pushEndTag }

		rules["tagName"]						= tagNameRule(sequence([anyAlphaChar, zeroOrMore(anyCharNotOf("\t\n\f />".chars))]))

		rules["voidElementName"]				= firstOf("area base br col embed hr img input keygen link meta param source track wbr"	.split.map { tagNameRule(str(it)) })
		rules["rawTextElementName"]				= firstOf("script style"																.split.map { tagNameRule(str(it)) })
		rules["escapableRawTextElementName"]	= firstOf("textarea title"																.split.map { tagNameRule(str(it)) })

		rules["rawTextElementContent"]			= rawText
		rules["escapableRawTextElementContent"]	= zeroOrMore(firstOf([characterReference, escapableRawText]))
		rules["normalElementContent"]			= zeroOrMore(firstOf([characterReference, comment, cdata, normalElementText, element]))
		
		rules["rawText"]						= oneOrMore(sequence([onlyIfNot(firstOf("script style"  .split.map { str("</${it}>") })), anyChar]))	.withAction { ctx.pushText(it) }
		rules["escapableRawText"]				= oneOrMore(sequence([onlyIfNot(firstOf("textarea title".split.map { str("</${it}>") })), anyChar]))	.withAction { ctx.pushText(it) }
//		rules["normalElementText"]				= strNot("<")																							.withAction { ctx.pushText(it) }
		rules["normalElementText"]				= oneOrMore(anyCharNot('<'))																			.withAction { ctx.pushText(it) }
		
		rules["attributes"]						= zeroOrMore(firstOf([anySpaceChar, doubleAttribute, singleAttribute, unquotedAttribute, emptyAttribute]))
		rules["emptyAttribute"]					= nTimes(1, attributeName).withAction { ctx.pushAttrVal(ctx.attrName); ctx.pushAttr }	// can't put the action on attributeName
		rules["unquotedAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace,			oneOrMore(firstOf([characterReference, anyCharNotOf(" \t\n\r\f\"'=<>`".chars).withAction { ctx.pushAttrVal(it) }])).withAction { ctx.pushAttr } ])
		rules["singleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('\''),oneOrMore(firstOf([characterReference, anyCharNotOf(			   "'".chars).withAction { ctx.pushAttrVal(it) }])).withAction { ctx.pushAttr }, char('\'')])
		rules["doubleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('"'),  oneOrMore(firstOf([characterReference, anyCharNotOf(		 	  "\"".chars).withAction { ctx.pushAttrVal(it) }])).withAction { ctx.pushAttr }, char('"')])
		rules["attributeName"]					= oneOrMore(anyCharNotOf(" \t\n\r\f\"'>/=".chars)) 																									 .withAction { ctx.pushAttrName(it) }
		
		rules["characterReference"]				= firstOf([decNumCharRef, hexNumCharRef])		
		rules["decNumCharRef"]					= sequence([str("&#"), oneOrMore(anyNumChar), char(';')])																	.withAction { ctx.pushDecCharRef(it) }
		rules["hexNumCharRef"]					= sequence([str("&#x"), oneOrMore(firstOf([anyNumChar, anyCharInRange('a'..'f'), anyCharInRange('A'..'F')])), char(';')]) 	.withAction { ctx.pushHexCharRef(it) }		

		rules["cdata"]							= sequence([str("<![CDATA["), strNot("]]>"), str("]]>")]).withAction { ctx.pushCdata(it) }

		rules["comment"]						= sequence([str("<!--"), strNot("--"), str("-->")])

		rules["doctype"]						= sequence([str("<!DOCTYPE"), oneOrMore(anySpaceChar), oneOrMore(anyAlphaNumChar).withAction { ctx.pushDoctype(it) }, zeroOrMore(firstOf([doctypeSystemId, doctypePublicId])), whitespace, str(">")])
		rules["doctypeSystemId"]				= sequence([oneOrMore(anySpaceChar), str("SYSTEM"), oneOrMore(anySpaceChar), firstOf([sequence([char('"'), zeroOrMore(anyCharNot('"')).withAction { ctx.pushSystemId(it) }, char('"')]), sequence([char('\''), zeroOrMore(anyCharNot('\'')).withAction { ctx.pushSystemId(it) }, char('\'')])])])
		rules["doctypePublicId"]				= sequence([oneOrMore(anySpaceChar), str("PUBLIC"), oneOrMore(anySpaceChar), firstOf([sequence([char('"'), zeroOrMore(anyCharNot('"')).withAction { ctx.pushPublicId(it) }, char('"')]), sequence([char('\''), zeroOrMore(anyCharNot('\'')).withAction { ctx.pushPublicId(it) }, char('\'')])])])
		
		rules["whitespace"]						= zeroOrMore(anySpaceChar)
		
		return preamble
	}
	
	Rule tagNameRule(Rule rule) {
		sequence([rule.withAction { ctx.pushTagName(it) }, zeroOrMore(anySpaceChar)])
	}
	
	ParseCtx ctx() {
		Actor.locals["afHtmlParser.ctx"]
	}
}
