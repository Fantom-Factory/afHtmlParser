using xml

@Js
internal class HtmlParserTest : Test {

	static const Unsafe	parserRef := Unsafe(HtmlParser())
	static HtmlParser	parser() { parserRef.val }

//	override Void setup() {
//		PegCtx#.pod.log.level = LogLevel.debug
//	}
	
	Void verifyElemEq(XElem elem, Str xml) {
		act := elem.writeToStr.replace("\n", "")
		exp := XParser(xml.in).parseDoc.root.writeToStr.replace("\n", "")
		verifyEq(act, exp)
	}
	
}
