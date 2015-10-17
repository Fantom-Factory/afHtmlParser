using build

class Build : BuildPod {

	new make() {
		podName = "afHtmlParser"
		summary = "Parses HTML strings into XML documents"
		summary = "Because only Chuck Norris can parse HTML with regular expressions"
		version = Version("0.0.3")

		meta = [
			"proj.name"		: "HTML Parser",
			"repo.internal"	: "true",
			"repo.tags"		: "web",
			"repo.public"	: "false"
		]

		depends = [
			"sys 1.0",
			"xml 1.0",

			// ---- Core ------------------------
			"afPegger 0.0.5+"	// FIXME: 0.0.6
		]
	
		srcDirs = [`test/`, `fan/`]
		resDirs = [`doc/`]
		
		meta["afBuild.docApi"] = "false"
		meta["afBuild.docSrc"] = "false"
	}
}
