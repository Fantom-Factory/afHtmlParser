using build

class Build : BuildPod {

	new make() {
		podName = "afHtmlParser"
		summary = "Parses HTML strings into XML documents"
		summary = "Because only Chuck Norris can parse HTML with regular expressions"
		version = Version("0.0.3")

		meta = [
			"proj.name"		: "HTML Parser",
			"internal"		: "true",
			"tags"			: "web",
			"repo.private"	: "true"
		]

		depends = [
			"sys 1.0",
			"concurrent 1.0",	// TODO: remove dependency on concurrent

			// ---- Core ------------------------
			"afPegger 0+",
			"xml 1.0"			
		]
	
		srcDirs = [`test/`, `fan/`]
		resDirs = [,]
	}
}
