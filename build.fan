using build

class Build : BuildPod {

	new make() {
		podName = "afHtmlParser"
		summary = "Parses HTML text into XML documents"
		summary = "Because only Chuck Norris can parse HTML with regular expressions"
		version = Version("0.2.2")

		meta = [
			"pod.dis"			: "HTML Parser",
			"repo.internal"		: "true",
			"repo.tags"			: "templating, web",
			"repo.public"		: "true"
		]

		depends = [
			"sys 1.0",
			"xml 1.0",

			// ---- Core ------------------------
			"afPegger 1.1.0 - 1.1"
		]
	
		srcDirs = [`fan/`, `test/`]
		resDirs = [`doc/`, `res/`]
	}
}
