using afPegger::PegParseErr

internal class TestBadAttrs : HtmlParserTest {

	Void testBadAttrs() {
		
		verifyErrMsg(PegParseErr#, "Bad attr quote") {
			parser.parseDoc("""<form action="/login/login" method="post>""")
		}		

		verifyErrMsg(PegParseErr#, "Bad attr quote") {
			parser.parseDoc("""<form action="/login/login" method='post>""")
		}
	}
}
