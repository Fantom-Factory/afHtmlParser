using afPegger
using concurrent

internal class HtmlRules : Rules {
	
	Rule rootRule() {
		rules := NamedRules()

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
		
		cdata							:= rules["cdata"]
		
		comment							:= rules["comment"]

		doctype							:= rules["doctype"]
		doctypeSystemId					:= rules["doctypeSystemId"]
		doctypePublicId					:= rules["doctypePublicId"]

		whitespace						:= zeroOrMore(anySpaceChar)
		blurb							:= zeroOrMore(firstOf([oneOrMore(anySpaceChar), comment]))

		rules["preamble"]						= sequence([bom, blurb, optional(doctype), xml, blurb, element, blurb])
		rules["bom"]							= optional(str("\uFEFF"))
		rules["xml"]							= optional(sequence([str("<?xml"), strNot("?>") ,str("?>")]))
		
		rules["element"]						= firstOf([voidElement, rawTextElement, escapableRawTextElement, selfClosingElement, normalElement])

		rules["voidElement"]					= sequence([char('<'), voidElementName, attributes, char('>')])				.withAction { ctx.pushVoidTag }
		rules["rawTextElement"]					= sequence([rawTextElementTag, rawTextElementContent, endTag])
		rules["escapableRawTextElement"]		= sequence([escapableRawTextElementTag, escapableRawTextElementContent, endTag])
		rules["selfClosingElement"]				= sequence([char('<'), tagName, attributes, str("/>")])						.withAction { ctx.pushVoidTag }
		rules["normalElement"]					= sequence([startTag, optional(normalElementContent), endTag])

		rules["rawTextElementTag"]				= sequence([char('<'), rawTextElementName, attributes, char('>')])			.withAction { ctx.pushStartTag }
		rules["escapableRawTextElementTag"]		= sequence([char('<'), escapableRawTextElementName, attributes, char('>')])	.withAction { ctx.pushStartTag }

		rules["startTag"]						= sequence([char('<'), tagName, attributes, char('>')])						.withAction { ctx.pushStartTag }
		rules["endTag"]							= sequence([str("</"), tagName, char('>')])									.withAction { ctx.pushEndTag }

		rules["tagName"]						= tagNameRule(sequence([anyAlphaChar, zeroOrMore(anyCharNotOf("\t\n\f />".chars))]))

		rules["voidElementName"]				= firstOf("area base br col embed hr img input keygen link meta param source track wbr"	.split.map { tagNameRule(str(it)) })
		rules["rawTextElementName"]				= firstOf("script style"																.split.map { tagNameRule(str(it)) })
		rules["escapableRawTextElementName"]	= firstOf("textarea title"																.split.map { tagNameRule(str(it)) })

		rules["rawTextElementContent"]			= rawText
		rules["escapableRawTextElementContent"]	= zeroOrMore(firstOf([escapableRawText, characterReference]))
		rules["normalElementContent"]			= sequence([onlyIfNot(str("</")), zeroOrMore(firstOf([normalElementText, characterReference, comment, cdata, element]))])
		
		rules["rawText"]						= oneOrMore(sequence([onlyIfNot(firstOf("script style"  .split.map { str("</${it}>") })), anyChar]))				.withAction { ctx.pushText(it) }
		rules["escapableRawText"]				= oneOrMore(sequence([onlyIfNot(firstOf("textarea title".split.map { str("</${it}>") }.add(char('&')))), anyChar]))	.withAction { ctx.pushText(it) }
		rules["normalElementText"]				= oneOrMore(anyCharNotOf("<&".chars))																				.withAction { ctx.pushText(it) }
		
		rules["attributes"]						= zeroOrMore(sequence([onlyIf(anyCharNotOf("/>".chars)), firstOf([anySpaceChar, doubleAttribute, singleAttribute, unquotedAttribute, emptyAttribute])]))
		rules["emptyAttribute"]					= nTimes(1, attributeName).withAction { ctx.pushAttrVal(ctx.attrName); ctx.pushAttr }	// can't put the action on attributeName
		rules["unquotedAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace,			   oneOrMore(firstOf([anyCharNotOf(" \t\n\r\f\"'=<>`&".chars)	.withAction { ctx.pushAttrVal(it) }, characterReference])).withAction { ctx.pushAttr } ])
		rules["singleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('\''), zeroOrMore(firstOf([anyCharNotOf(		 	      "'&".chars)	.withAction { ctx.pushAttrVal(it) }, characterReference])).withAction { ctx.pushAttr }, char('\'')])
		rules["doubleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('"'),  zeroOrMore(firstOf([anyCharNotOf(		 	     "\"&".chars)	.withAction { ctx.pushAttrVal(it) }, characterReference])).withAction { ctx.pushAttr }, char('"')])
		rules["attributeName"]					= oneOrMore(anyCharNotOf(" \t\n\r\f\"'>/=".chars)) 																							  			.withAction { ctx.pushAttrName(it) }
		
		rules["characterReference"]				= sequence([onlyIf(char('&')), firstOf([decNumCharRef, hexNumCharRef, namedCharRef])])		
		rules["namedCharRef"]					= sequence([str("&"), oneOrMore(anyCharNot(';')), char(';')]) 	.withAction { ctx.pushNomCharRef(it) }		
		rules["decNumCharRef"]					= sequence([str("&#"), oneOrMore(anyNumChar), char(';')])		.withAction { ctx.pushDecCharRef(it) }
		rules["hexNumCharRef"]					= sequence([str("&#x"), oneOrMore(anyHexChar), char(';')])		.withAction { ctx.pushHexCharRef(it) }		

		rules["cdata"]							= sequence([str("<![CDATA["), strNot("]]>"), str("]]>")]).withAction { ctx.pushCdata(it) }

		rules["comment"]						= sequence([str("<!--"), strNot("--"), str("-->")])

		rules["doctype"]						= sequence([str("<!DOCTYPE"), oneOrMore(anySpaceChar), oneOrMore(anyAlphaNumChar).withAction { ctx.pushDoctype(it) }, zeroOrMore(firstOf([doctypeSystemId, doctypePublicId])), whitespace, str(">")])
		rules["doctypeSystemId"]				= sequence([oneOrMore(anySpaceChar), str("SYSTEM"), oneOrMore(anySpaceChar), firstOf([sequence([char('"'), zeroOrMore(anyCharNot('"')).withAction { ctx.pushSystemId(it) }, char('"')]), sequence([char('\''), zeroOrMore(anyCharNot('\'')).withAction { ctx.pushSystemId(it) }, char('\'')])])])
		rules["doctypePublicId"]				= sequence([oneOrMore(anySpaceChar), str("PUBLIC"), oneOrMore(anySpaceChar), firstOf([sequence([char('"'), zeroOrMore(anyCharNot('"')).withAction { ctx.pushPublicId(it) }, char('"')]), sequence([char('\''), zeroOrMore(anyCharNot('\'')).withAction { ctx.pushPublicId(it) }, char('\'')])])])
		
		return preamble
	}
	
	Rule tagNameRule(Rule rule) {
		sequence([rule.withAction { ctx.pushTagName(it) }, zeroOrMore(anySpaceChar)])
	}
	
	SuccessCtx ctx() {
		Actor.locals["afHtmlParser.successCtx"]
	}
}

//internal class StartTagRule : Rule {
//	private Rule rule
//	
//	new make(Rule rule) {
//		this.rule = rule
//	}
//	
//	override Bool doProcess(PegCtx ctx) {
//		passed := ctx.process(rule)
//		if (passed) {
//			tagName := ctx.matched.trim
//			pctx.tagStack.push(tagName)
//		}
//		return passed
//	}
//	
//	override Str expression() { rule.expression }
//	
//	ParseCtx pctx() {
//		Actor.locals["afHtmlParser.parseCtx"]
//	}
//}
//
//internal class EndTagRule : Rule {
//	private Rule rule
//	
//	new make(Rule rule) {
//		this.rule = rule
//	}
//	
//	override Bool doProcess(PegCtx ctx) {
//		passed := ctx.process(rule)
//		if (passed) {
//			tagName := ctx.matched.trim
//			stack	:= pctx.tagStack.peek
//			if (!tagName.equalsIgnoreCase(stack))
//				throw ParseErr("End tag </${tagName}> does not match start tag <${stack}>")
//			pctx.tagStack.pop
//		}
//		return passed
//	}
//	
//	override Str expression() { rule.expression }
//	
//	ParseCtx pctx() {
//		Actor.locals["afHtmlParser.parseCtx"]
//	}
//}
