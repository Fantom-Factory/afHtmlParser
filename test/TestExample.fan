
class TestExample : Test {
	
	Void testExample() {
		elem := HtmlParser().parseDoc("<input disabled value=wotever>")
		echo(elem.writeToStr)	// --> <input disabled='disabled' value='wotever'/>
	}
}
