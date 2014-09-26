
class TestEndTagRule: Test {
	
	// need to bring back rollback funcs
//	Void testTagMismatch() {
//		verifyErrMsg(ParseErr#, "End tag </oops> does not match start tag <title>") {
//			HtmlParser().parseDoc("<html><title>Dude!</oops>")
//		}
//	}
	
	protected Void verifyErrMsg(Type errType, Str errMsg, |Obj| func) {
		try {
			func(4)
		} catch (Err e) {
			if (!e.typeof.fits(errType)) 
				throw Err("Expected $errType got $e.typeof", e)
			verifyEq(errMsg, e.msg)	// this gives the Str comparator in eclipse
			return
		}
		throw Err("$errType not thrown")
	}
}