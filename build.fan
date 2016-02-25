using build

class Build : BuildPod {

	new make() {
		podName = "afHtmlParser"
		summary = "Parses HTML text into XML documents"
		summary = "Because only Chuck Norris can parse HTML with regular expressions"
		version = Version("0.1.0")

		meta = [
			"proj.name"		: "HTML Parser",
			"repo.internal"	: "true",
			"repo.tags"		: "templating, web",
			"repo.public"	: "false"
		]

		depends = [
			"sys 1.0",
			"xml 1.0",

			// ---- Core ------------------------
			"afPegger 0.1.0 - 0.1"
		]
	
		srcDirs = [`fan/`, `test/`]
		resDirs = [`doc/`]
	}
}
