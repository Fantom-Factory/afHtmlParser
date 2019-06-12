
@Js
internal class TestExample : HtmlParserTest {
	
	Void testExample() {
		elem := parser.parseDoc("<input disabled value=wotever>")
		echo(elem.writeToStr)	// --> <input disabled='disabled' value='wotever'/>
	}
}
