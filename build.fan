using build

class Build : BuildPod {

	new make() {
		podName = "afHtmlParser"
		summary = "Parses HTML strings into XML documents"
		version = Version("0.0.2")

		meta = [
			"proj.name"		: "HTML Parser",
			"internal"		: "true",
			"tags"			: "web",
			"repo.private"	: "true"
		]

		depends = [
			"sys 1.0",
			"concurrent 1.0",

			// ---- Core ------------------------
			"afPegger 0+",
			"xml 1.0"			
		]
	
		srcDirs = [`test/`, `fan/`]
		resDirs = [,]
	}
}
