using afPegger

@Js
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
		borkedRef						:= rules["borkedRef"]
		
		cdata							:= rules["cdata"]
		
		comment							:= rules["comment"]

		doctype							:= rules["doctype"]
		doctypePublicId					:= rules["doctypePublicId"]
		doctypeSystemId					:= rules["doctypeSystemId"]

		whitespace						:= zeroOrMore(anySpaceChar)
		blurb							:= zeroOrMore(firstOf([oneOrMore(anySpaceChar), comment]))

		rules["preamble"]						= sequence([bom, blurb, optional(doctype), xml, blurb, element, blurb])
		rules["bom"]							= optional(str("\uFEFF"))
		rules["xml"]							= optional(sequence([str("<?xml"), strNot("?>") ,str("?>")]))
		
		rules["element"]						= firstOf([voidElement, rawTextElement, escapableRawTextElement, selfClosingElement, normalElement])

		rules["voidElement"]					= sequence([char('<'), voidElementName, attributes, char('>')])				.withAction |s,tx| { c(tx).pushVoidTag }
		rules["rawTextElement"]					= sequence([rawTextElementTag, rawTextElementContent, endTag])
		rules["escapableRawTextElement"]		= sequence([escapableRawTextElementTag, escapableRawTextElementContent, endTag])
		rules["selfClosingElement"]				= sequence([char('<'), tagName, attributes, str("/>")])						.withAction |s,tx| { c(tx).pushVoidTag }
		rules["normalElement"]					= sequence([startTag, optional(normalElementContent), endTag])

		rules["rawTextElementTag"]				= sequence([char('<'), rawTextElementName, attributes, char('>')])			.withAction |s,tx| { c(tx).pushStartTag }
		rules["escapableRawTextElementTag"]		= sequence([char('<'), escapableRawTextElementName, attributes, char('>')])	.withAction |s,tx| { c(tx).pushStartTag }

		rules["startTag"]						= sequence([char('<'), tagName, attributes, char('>')])						.withAction |s,tx| { c(tx).pushStartTag }
		rules["endTag"]							= sequence([str("</"), tagName, char('>')])									.withAction |s,tx| { c(tx).pushEndTag }

		rules["tagName"]						= tagNameRule(sequence([anyAlphaChar, zeroOrMore(anyCharNotOf("\t\n\f />".chars))]))

		rules["voidElementName"]				= firstOf("area base br col embed hr img input keygen link meta param source track wbr"	.split.map { tagNameRule(str(it)) })
		rules["rawTextElementName"]				= firstOf("script style"																.split.map { tagNameRule(str(it)) })
		rules["escapableRawTextElementName"]	= firstOf("textarea title"																.split.map { tagNameRule(str(it)) })

		rules["rawTextElementContent"]			= rawText
		rules["escapableRawTextElementContent"]	= zeroOrMore(firstOf([escapableRawText, characterReference]))
		rules["normalElementContent"]			= sequence([onlyIfNot(str("</")), zeroOrMore(firstOf([normalElementText, characterReference, comment, cdata, element]))])
		
		rules["rawText"]						= oneOrMore(sequence([onlyIfNot(firstOf("script style"  .split.map { str("</${it}>") })), anyChar]))				.withAction |s,tx| { c(tx).pushText(s) }
		rules["escapableRawText"]				= oneOrMore(sequence([onlyIfNot(firstOf("textarea title".split.map { str("</${it}>") }.add(char('&')))), anyChar]))	.withAction |s,tx| { c(tx).pushText(s) }
		rules["normalElementText"]				= oneOrMore(anyCharNotOf("<&".chars))																				.withAction |s,tx| { c(tx).pushText(s) }
		
		rules["attributes"]						= zeroOrMore(sequence([onlyIf(anyCharNotOf("/>".chars)), firstOf([anySpaceChar, doubleAttribute, singleAttribute, unquotedAttribute, emptyAttribute])]))
		rules["emptyAttribute"]					= nTimes(1, attributeName).withAction |s,tx| { c(tx).pushAttrVal(c(tx).attrName); c(tx).pushAttr }	// can't put the action on attributeName
		rules["unquotedAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace,			   oneOrMore(firstOf([anyCharNotOf(" \t\n\r\f\"'=<>`&".chars)	.withAction |s,tx| { c(tx).pushAttrVal(s) }, characterReference])).withAction |s,tx| { c(tx).pushAttr } ])
		rules["singleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('\''), zeroOrMore(firstOf([anyCharNotOf(		 	      "'&".chars)	.withAction |s,tx| { c(tx).pushAttrVal(s) }, characterReference])).withAction |s,tx| { c(tx).pushAttr }, char('\'')])
		rules["doubleAttribute"]				= sequence([attributeName, whitespace, char('='), whitespace, char('"'),  zeroOrMore(firstOf([anyCharNotOf(		 	     "\"&".chars)	.withAction |s,tx| { c(tx).pushAttrVal(s) }, characterReference])).withAction |s,tx| { c(tx).pushAttr }, char('"')])
		rules["attributeName"]					= oneOrMore(anyCharNotOf(" \t\n\r\f\"'>/=".chars)) 																						.withAction |s,tx| { c(tx).pushAttrName(s) }
		
		rules["characterReference"]				= sequence([onlyIf(char('&')), firstOf([decNumCharRef, hexNumCharRef, namedCharRef, borkedRef])])		
		rules["namedCharRef"]					= sequence([char('&'), oneOrMore(anyCharNotOf(";>".chars)), char(';')]) .withAction |s,tx| { c(tx).pushNomCharRef(s) }
		rules["decNumCharRef"]					= sequence([str("&#"), oneOrMore(anyNumChar), char(';')])				.withAction |s,tx| { c(tx).pushDecCharRef(s) }
		rules["hexNumCharRef"]					= sequence([str("&#x"), oneOrMore(anyHexChar), char(';')])				.withAction |s,tx| { c(tx).pushHexCharRef(s) }		
		rules["borkedRef"]						= sequence([char('&'), onlyIf(anySpaceChar)])							.withAction |s,tx| { c(tx).pushBorkedRef (s) }		

		rules["cdata"]							= sequence([str("<![CDATA["), strNot("]]>"), str("]]>")]).withAction |s,tx| { c(tx).pushCdata(s) }

		rules["comment"]						= sequence([str("<!--"), strNot("--"), str("-->")])

		rules["doctype"]						= sequence([str("<!DOCTYPE"), oneOrMore(anySpaceChar), oneOrMore(anyAlphaNumChar).withAction |s,tx| { c(tx).pushDoctype(s) }, zeroOrMore(firstOf([doctypePublicId, doctypeSystemId])), whitespace, str(">")])
		rules["doctypePublicId"]				= sequence([oneOrMore(anySpaceChar), str("PUBLIC"), oneOrMore(anySpaceChar), firstOf([sequence([char('"'), zeroOrMore(anyCharNot('"')).withAction |s,tx| { c(tx).pushPublicId(s) }, char('"')]), sequence([char('\''), zeroOrMore(anyCharNot('\'')).withAction |s,tx| { c(tx).pushPublicId(s) }, char('\'')])])])
		rules["doctypeSystemId"]				= sequence([oneOrMore(anySpaceChar), optional(sequence([str("SYSTEM"), oneOrMore(anySpaceChar)])), firstOf([sequence([char('"'), zeroOrMore(anyCharNot('"')).withAction |s,tx| { c(tx).pushSystemId(s) }, char('"')]), sequence([char('\''), zeroOrMore(anyCharNot('\'')).withAction |s,tx| { c(tx).pushSystemId(s) }, char('\'')])])])
		
		return preamble
	}
	
	Rule tagNameRule(Rule rule) {
		sequence([rule.withAction |s,tx| { c(tx).pushTagName(s) }, zeroOrMore(anySpaceChar)])
	}
	
	SuccessCtx c(Obj ctx) { ctx }
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
