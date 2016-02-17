using build

class Build : BuildPod {

	new make() {
		podName = "afHtmlParser"
		summary = "Parses HTML strings into XML documents"
		summary = "Because only Chuck Norris can parse HTML with regular expressions"
		version = Version("0.0.4")

		meta = [
			"proj.name"		: "HTML Parser",
			"repo.internal"	: "true",
			"repo.tags"		: "web",
			"repo.public"	: "true"
		]

		depends = [
			"sys 1.0",
			"concurrent 1.0",	// TODO: remove dependency on concurrent

			// ---- Core ------------------------
			"afPegger 0.0.4 - 0.0",
			"xml 1.0"
		]
	
		srcDirs = [`fan/`, `test/`]
		resDirs = [`doc/`]
		
		meta["afBuild.docApi"] = "false"
		meta["afBuild.docSrc"] = "false"
	}
}
