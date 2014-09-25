
internal class TestFantomFactory : HtmlParserTest {
	
	Void testFfWebSite() {
//		PegCtx#.pod.log.level = LogLevel.debug

		HtmlParser().parseDocument(website)
	}	
	
	Str website := 
"""<!DOCTYPE html><html prefix="og: http://ogp.me/ns#" xmlns="http://www.w3.org/1999/xhtml" xmlns:svg="http://www.w3.org/2000/svg"><head><title>Home :: Fantom-Factory</title><meta id="viewport" name="viewport" content="initial-scale=1.0"><link rel="alternate" type="application/atom+xml" title="Fantom Factory" href="/feeds/all"><link href="https://plus.google.com/+FantomFactoryOrgy" rel="publisher"><link rel="shortcut icon" href="/favicon.ico"><link rel="apple-touch-icon" sizes="57x57"   href="/favicons/apple-touch-icon-57x57.png"><link rel="apple-touch-icon" sizes="60x60"   href="/favicons/apple-touch-icon-60x60.png"><link rel="apple-touch-icon" sizes="72x72"   href="/favicons/apple-touch-icon-72x72.png"><link rel="apple-touch-icon" sizes="76x76"   href="/favicons/apple-touch-icon-76x76.png"><link rel="apple-touch-icon" sizes="114x114" href="/favicons/apple-touch-icon-114x114.png"><link rel="apple-touch-icon" sizes="120x120" href="/favicons/apple-touch-icon-120x120.png"><link rel="apple-touch-icon" sizes="144x144" href="/favicons/apple-touch-icon-144x144.png"><link rel="apple-touch-icon" sizes="152x152" href="/favicons/apple-touch-icon-152x152.png"><link rel="icon" type="image/png" href="/favicons/favicon-16x16.png"   sizes="16x16"><link rel="icon" type="image/png" href="/favicons/favicon-32x32.png"   sizes="32x32"><link rel="icon" type="image/png" href="/favicons/favicon-96x96.png"   sizes="96x96"><link rel="icon" type="image/png" href="/favicons/favicon-160x160.png" sizes="160x160"><link rel="icon" type="image/png" href="/favicons/favicon-196x196.png" sizes="196x196"><meta name="application-name"			content="Fantom-Factory"><meta name="apple-mobile-web-app-title"	content="Fantom-Factory"><meta name="msapplication-TileColor"	content="#00A300"><meta name="msapplication-TileImage"	content="/favicons/mstile-144x144.png"><meta name="msapplication-config"		content="/favicons/browserconfig.xml"><script type="text/javascript">
   	(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
   	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
   	m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
   	})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
   	ga('create', 'UA-33997125-4', 'fantomfactory.org');
   	ga('send', 'pageview');
   </script>
   
   <meta name="google-site-verification" content="j2bYSt75mVPPEDdKvO7e7hkHXesAWP3rfHSf5ZkFzXU">
   <meta name="description" content="Libraries and articles for the Fantom programming language; made by Alien-Factory.">
   <link rel="stylesheet" type="text/css" href="/coldFeet/JglBFw==/css/bootstrap.min.css">
   <link rel="stylesheet" type="text/css" href="/coldFeet/_F1aQA==/css/website.min.css">
   <meta property="og:type" content="website">
   <meta property="og:title" content="Fantom-Factory Website">
   <meta property="og:url" content="http://www.fantomfactory.org/">
   <meta property="og:image" content="http://www.fantomfactory.org/coldFeet/0Dm2NA==/images/index/fantomFactory.ogimage.png">
   <meta property="og:description" content="Libraries and articles for the Fantom programming language; made by Alien-Factory.">
   <meta property="og:locale" content="en_GB">
   <meta property="og:site_name" content="Fantom-Factory">
   </head><body id="top" class="envProd"><div class="hive-background"><div class="hive-glow"><div class="glow g1 right"></div><div class="glow g2 left hidden-xs"></div><div class="glow g3 right"></div><div class="glow g4 left hidden-xs"></div></div><div class="hive-hex"></div><div class="hive-round1"></div><div class="hive-round2"></div></div><nav class="navbar navbar-default navbar-fixed-top" role="navigation"><div class="container"><div class="navbar-header"><button class="navbar-toggle" type="button" data-toggle="collapse" data-target=".navbar-mobile"><span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button><a class="navbar-brand" rel="home" href="/"><svg class="factoryLogo" xmlns="http://www.w3.org/2000/svg" viewBox="340 140 320 220" preserveAspectRatio="xMinYMin">
   	<defs>
   		<filter id="css-glow-20">
   			<feGaussianBlur stdDeviation="20" in="SourceAlpha" result="blur"></feGaussianBlur>
   			<feFlood flood-color="#20ee23"></feFlood>
   			<feComposite operator="in" in2="blur"></feComposite>
   			<feMerge>
   				<feMergeNode></feMergeNode>
   				<feMergeNode in="SourceGraphic"></feMergeNode>
   			</feMerge>
   		</filter>
   		<filter id="css-glow-15">
   			<feGaussianBlur stdDeviation="15" in="SourceAlpha" result="blur"></feGaussianBlur>
   			<feFlood flood-color="#20ee23"></feFlood>
   			<feComposite operator="in" in2="blur"></feComposite>
   			<feMerge>
   				<feMergeNode></feMergeNode>
   				<feMergeNode in="SourceGraphic"></feMergeNode>
   			</feMerge>
   		</filter>
   	</defs>
   	<g>
   		<path class="factoryLogo-outline" filter="url(#css-glow-20)" d="M504.731 150.962c-0.014 0.4 24.98-0.467 24.98-0.467s0.855 18.4 1.1 26.9 c0.616 26.388-3.983 23.8 23.7 28.377c30.458 5 60.8 10.5 91.3 15.669c7.641 1.3 12.2 3.7 12 13.4 c-0.532 25.4 0.1 50.8 0.9 76.183c0.188 5.988-3.534 11.094-2.311 17.065c0.421 2.056-1.208 2.606-3.103 2.8 c-11.727 1.271-23.424 2.849-35.166 3.954c-22.174 2.086-44.226 5.171-66.333 7.727c-16.257 1.879-32.477 4.531-48.683 5.8 c-12.299 0.958-25.054-3.264-37.542-5.534c-24.91-4.529-49.741-9.501-74.691-13.786c-4.468-0.767-13.513-2.245-13.513-2.245 l-4.343-4.632c0.438-11.009 0.418-22.045 1.167-33.031c0.449-6.599 4.643-10.967 10.937-12.958 c6.673-2.112 13.523-3.688 20.129-5.979c12.214-4.236 17.753-11.202 16.784-23.945c-0.765-10.065 3.933-14.448 12.172-17.829 c12.037-4.94 23.782-10.59 35.728-15.759c5.7-2.467 7.496-6.158 7.172-12.577c0 0 1.07-31.958 1.505-44.851 c0.159-4.694 3.014-4.301 6.059-4.3C491.337 151 498 151 504.7 151 C504.736 150.8 504.7 151.1 504.7 150.962z"></path>
   		<path class="factoryLogo-wall" d="M651.977 272.597c0.156 13.042-0.257 26.1 0.7 39.111c0.65 9.22-3.646 12.814-11.677 13.6 c-11.298 1.089-22.628 1.862-33.945 2.754c-30.305 2.388-60.616 4.709-90.913 7.188c-8.129 0.665-11.875-2.506-11.373-10.875 c2.22-37.028 2.113-74.105 1.805-111.172c-0.056-6.775 0.699-9.06 8.634-7.735c44.463 7.4 89 14.1 133.6 21 c1.31 0.2 2.7 0.3 3.1 1.837C651.169 243.1 651 257.8 652 272.597z"></path>
   	</g>
   </svg>
   <span class="fantomFactoryText">Fantom<span class="factory">-Factory</span></span></a></div><div class="hidden-sm hidden-md hidden-lg navbar-mobile collapse"><ul class="nav navbar-nav"><li class="dropdown"><a href="/pods/"><div class="title"><i class="fa fa-circle-o-notch"></i> Pods</div></a></li><li class="dropdown"><a href="/articles/"><div class="title"><i class="fa fa-book"></i> Articles</div></a></li></ul></div><div class="navbar-desktop"><ul class="nav navbar-nav navbar-right"><li class="dropdown"><a class="dropdown-toggle" href="#"><i class="visible-lg-inline fa fa-circle-o-notch"></i> Pods <b class="caret"></b></a><ul class="dropdown-menu"><li><a href="/pods/"><div class="title">-- All Pods --</div></a></li><li class="divider"></li><li><a href="/pods/afBedSheet">BedSheet 1.3.16</a></li><li><a href="/pods/afBounce">Bounce 1.0.14</a></li><li><a href="/pods/afEfan">efan 1.4.2</a></li><li><a href="/pods/afEfanXtra">efanXtra 1.1.16</a></li><li><a href="/pods/afFancordion">Fancordion 0.0.4</a></li><li><a href="/pods/afIoc">IoC 2.0.0</a></li><li><a href="/pods/afMongo">Mongo 0.0.6</a></li><li><a href="/pods/afPillow">Pillow 1.0.20</a></li><li><a href="/pods/afSizzle">Sizzle 1.0.0</a></li><li><a href="/pods/afSlim">Slim 1.1.8</a></li></ul></li><li class="dropdown"><a class="dropdown-toggle" href="#"><i class="visible-lg-inline fa fa-book"></i> Articles <b class="caret"></b></a><ul class="dropdown-menu"><li><a href="/articles/"><div class="title">-- All Articles --</div></a></li><li class="divider"></li><li><a href="/articles/fantom-for-beginners">Fantom For Beginners</a></li><li><a href="/articles/from-java-to-fantom-in-10-steps">Java to Fantom in 10 Steps</a></li><li><a href="/articles/intro-to-f4">An Introduction to the F4 IDE</a></li><li><a href="/articles/writing-ioc-services">IoC Tutorial</a></li><li><a href="/articles/bed-nap-tutorial">Web App Tutorial</a></li><li><a href="/articles/run-fantom-code-in-a-browser">Run Fantom Code In a Browser!</a></li><li><a href="/articles/fantom-faster-than-java-and-kotlin">Fantom - Faster than Java and Kotlin!</a></li></ul></li><li><form class="navbar-form" role="search" action="/search" method="GET"><div class="input-group"><input class="form-control input-sm" type="search" name="q" placeholder="Search"><div class="input-group-btn"><button class="btn btn-default input-sm" type="submit"><i class="fa fa-search"></i></button></div></div></form></li></ul></div></div></nav><main id="indexPage" class="container"><h1 class="text-center"><div class="title"><span class="blend">Inspiring Next Generation Programmers		</span></div><div class="line"></div><div class="tag space"><span class="blend">Software</span><span class="small blend"> for</span><span class="blend">&#160;Fantom
   
   
   </span></div></h1><a href="#newReleases" data-ga-category="Misc Link" data-ga-label="New Releases"><div class="text-center"><b class="caret"></b> Fantom-Factory New Releases <b class="caret"></b></div></a><div class="divider"></div><div class="row feature"><div class="col-md-5"><a href="/articles/fantom-for-beginners" data-ga-category="Index Screenshot" data-ga-label="Fantom Website"><img class="img-rounded img-responsive block-center" src="/coldFeet/KD50dA==/images/index/fantomLogo.png" alt="Fantom for Beginners"></a></div><div class="col-md-7"><h2><span class="blend squish">What is Fantom? </span></h2><p class="lead"><span class="blend"><a class="externalLink" href="http://www.fantom.org/">Fantom</a> is an elegant open source, object-oriented, software language that runs on the Java Virtual Machine (JVM). </span></p><p class="lead"><span class="blend">Designed to be portable, Fantom also runs on the .NET Common Language Runtime (CLR) and even compiles to Javascript!</span></p><p class="lead"><span class="blend">Concise core APIs, familiar syntax and sensible libraries let you concentrate on the problem, not the language! 
   
   
   </span></p></div></div><div class="divider"></div><div class="row feature fantom"><div class="col-md-5 col-md-push-7"><a href="/articles/from-java-to-fantom-in-10-steps" data-ga-category="Index Screenshot" data-ga-label="10 Steps to Fantom"><img class="img-rounded img-responsive block-center" src="/coldFeet/yT4lTw==/images/index/10-steps-to-fantom.png" alt="From Java to Fantom in 10 Steps"></a></div><div class="col-md-7 col-md-pull-5"><h2><span class="blend">Why Fantom? 
   </span></h2><p class="lead"><span class="blend">Fantom strikes a unique balance between strong and dynamic typing. 
     It natively tackles all the hard stuff, like proper concurrency with Actors, so you don't have to! 
   </span></p><p class="lead"><span class="blend">It's easy to learn and easy to use; </span><span class="nowrap blend"><i>Fantom just works!</i>
   </span></p><p class="lead"><span class="blend">Whether a newbie or expert, Fantom-Factory is here to help you:  </span><span class="nowrap blend"><i>Get Proactive - Today!</i> 
   
   
   </span></p></div></div><div class="divider"></div><div class="row feature"><div class="col-md-5"><a href="http://bednap.fantomfactory.org/" data-ga-category="Index Screenshot" data-ga-label="Bed Nap"><img class="img-rounded img-responsive block-center" src="/coldFeet/hwTsjw==/images/index/bedNapWebsite.png" alt="Bed Nap - An sample Fantom web application to use as a project template."></a></div><div class="col-md-7"><h2><span class="blend">Write Web Applications! </span></h2><p class="lead"><span class="blend">Discover a wealth of APIs and libraries for creating exciting websites! Many of them hosted right here on <a href="http://www.fantomfactory.org/pods/#web">Fantom-Factory</a>! </span></p><p class="lead"><span class="blend">Take the Fantom <a href="http://bednap.fantomfactory.org/">Bed Nap</a> application for test drive, then use it as a project template!
   
   
   </span></p></div></div><div class="divider"></div><div class="row feature"><div class="col-md-5 col-md-push-7"><a href="http://www.alienfactory.co.uk/gundam/" data-ga-category="Index Screenshot" data-ga-label="Gundam"><img class="img-rounded img-responsive block-center" src="/coldFeet/cfSs8Q==/images/index/gundamScreenshot.jpg" alt="Gundam - a shoot'em'up game written in Fantom"></a></div><div class="col-md-7 col-md-pull-5"><h2><span class="blend">Write Games!</span></h2><p class="lead"><span class="blend">With graphic libraries for eclipse SWT and Javascript there's nothing to stop you! </span></p><p class="lead"><span class="blend">Play <a href="http://www.alienfactory.co.uk/gundam/">Gundam</a>, a shoot'em'up written in Fantom! Download it for desktop use, or play online in your browser! 
   
   
   </span></p></div></div><div class="divider"></div><div class="row feature"><div class="col-md-5"><a href="http://fantex.fantomfactory.org/" data-ga-category="Index Screenshot" data-ga-label="Fantex"><img class="img-rounded img-responsive block-center" src="/coldFeet/bv5yrA==/images/index/fantexWebsite.png" alt="Fantex - An online regular expression editor for Fantom"></a></div><div class="col-md-7"><h2><span class="blend">Write Anything!</span></h2><p class="lead"><span class="blend">Fantom connects to <a href="/pods/afMongo">Mongo</a> and <a class="externalLink" href="http://fantom.org/doc/sql/index.html">SQL</a> databases, 
     has powerful <a href="/pods/afIoc">IoC</a> libraries and <a href="/pods/afBedSheet">application servers</a>.
     Heck, it even has <a href="/pods/afFancomSapi">Speech Recognition</a>!</span></p><p class="lead"><span class="blend"><a class="externalLink" href="http://www.fantom.org/">Fantom</a> - suitable for desktop, embedded and browser applications. 
   
   
   </span></p></div></div><hr class="divider"><div id="index-google" class="row feature"><div class="col-md-4 col-md-push-8"><a href="//plus.google.com/communities/108121220239226647550" data-ga-category="Index Screenshot" data-ga-label="Google Community"><img class="img-rounded img-responsive block-center" src="/coldFeet/ptAlkg==/images/index/googleCommunity.png" alt="The Fantom Google Community"></a></div><div class="col-md-8 col-md-pull-4"><h2><div class="text-center"><span class="blend">Join us on <a href="//plus.google.com/communities/108121220239226647550">Google+</a></span></div></h2><p class="lead text-center"><span class="blend">Google+ is a great place to:</span><ul><li><span class="blend">Discuss projects</span></li><li><span class="blend">Ask for help</span></li><li><span class="blend">Meet other Fantom programmers</span></li></ul></p><p class="lead text-center"><span class="blend">Come say 'Hello!' and <i>Get Involved!</i>
   
   
   </span></p></div></div><hr id="newReleases" class="divider"><div class="row"><div class="col-sm-12 left"><h2 class="feature"><span class="blend">Meanwhile on Fantom-Factory...</span></h2><p class="lead"><span class="blend">These are the latest libraries &amp; articles to enhance &amp; guide your <a class="externalLink" href="http://www.fantom.org/">Fantom</a> programming experience.
   </span></p></div></div><div class="row"><div class="col-sm-6"><div class="sectionTitle"><h3><i class="fa fa-circle-o-notch"></i> Fantom Pods</h3></div><div class="resourceList"><ul class="list-unstyled"><li><article><a href="/pods/afEfanXtra"><h4><span class="blend"><span class="title">efanXtra 1.1.16</span><span class="text-muted nowrap"> - 15th Sep 2014 </span></span></h4><p><span class="blend">A library for creating reusable Embedded Fantom (efan) components 
   </span></p></a></article></li><li><article><a href="/pods/afBedNap"><h4><span class="blend"><span class="title">Bed Nap 0.0.20</span><span class="text-muted nowrap"> - 12th Sep 2014 </span></span></h4><p><span class="blend">A simple BedSheet application; use it to kickstart your own Bed Apps! 
   </span></p></a></article></li><li><article><a href="/pods/afColdFeet"><h4><span class="blend"><span class="title">Cold Feet 1.2.6</span><span class="text-muted nowrap"> - 12th Sep 2014 </span></span></h4><p><span class="blend">An asset caching strategy for your Bed Application<span class="text-muted"> (Internal)</span> 
   </span></p></a></article></li><li><article><a href="/pods/afDuvet"><h4><span class="blend"><span class="title">Duvet 1.0.2</span><span class="text-muted nowrap"> - 12th Sep 2014 </span></span></h4><p><span class="blend">Something soft and comfortable to wrap your Javascript up in! 
   </span></p></a></article></li><li><article><a href="/pods/afSitemap"><h4><span class="blend"><span class="title">Sitemap 0.0.16</span><span class="text-muted nowrap"> - 12th Sep 2014 </span></span></h4><p><span class="blend">A library for creating XML sitemaps for your Bed Application<span class="text-muted"> (Internal)</span> 
   </span></p></a></article></li><li><article><a href="/pods/afPillow"><h4><span class="blend"><span class="title">Pillow 1.0.20</span><span class="text-muted nowrap"> - 12th Sep 2014 </span></span></h4><p><span class="blend">Something for your web app to get its teeth into! 
   </span></p></a></article></li><li><article><a href="/pods/afGenesis"><h4><span class="blend"><span class="title">Genesis 0.0.20</span><span class="text-muted nowrap"> - 12th Sep 2014 </span></span></h4><p><span class="blend">A quick'n'dirty application for creating new Fantom projects<span class="text-muted"> (Internal)</span> 
   </span></p></a></article></li><li><article><a href="/pods/afBounce"><h4><span class="blend"><span class="title">Bounce 1.0.14</span><span class="text-muted nowrap"> - 12th Sep 2014 </span></span></h4><p><span class="blend">A library for testing BedSheet applications! 
   </span></p></a></article></li></ul></div></div><div class="col-sm-6"><div class="sectionTitle"><h3><i class="fa fa-book"></i> Fantom Articles</h3></div><div class="resourceList"><ul class="list-unstyled"><li><article><a href="/articles/bnt08-page-routing-with-pillow"><h4><span class="blend"><span class="title">Page Routing with Pillow</span><span class="text-muted nowrap"> - 4th Sep 2014 </span></span></h4><p><span class="blend">Article 8 of Web App Tutorial - How to use Pillow to automatically route request URLs to your efanXtra components. 
   </span></p></a></article></li><li><article><a href="/articles/bnt07-components-with-efanxtra"><h4><span class="blend"><span class="title">Components with efanXtra</span><span class="text-muted nowrap"> - 3rd Sep 2014 </span></span></h4><p><span class="blend">Article 7 of Web App Tutorial - How to convert efan templates into efanXtra components, deleting boilerplate code along the way. 
   </span></p></a></article></li><li><article><a href="/articles/bnt06-templating-with-efan"><h4><span class="blend"><span class="title">Templating with efan</span><span class="text-muted nowrap"> - 2nd Sep 2014 </span></span></h4><p><span class="blend">Article 6 of Web App Tutorial - How to use efan templates to generate HTML markup for the Bed Nap Web Application. 
   </span></p></a></article></li><li><article><a href="/articles/bnt05-testing-with-bounce"><h4><span class="blend"><span class="title">Testing with Bounce</span><span class="text-muted nowrap"> - 1st Sep 2014 </span></span></h4><p><span class="blend">Article 5 of Web App Tutorial - How to test the Bed Nap Web Application with the dedicated Bounce library. 
   </span></p></a></article></li><li><article><a href="/articles/bnt04-ids-and-valueencoders"><h4><span class="blend"><span class="title">IDs and ValueEncoders - Adding a View Page</span><span class="text-muted nowrap"> - 31st Aug 2014 </span></span></h4><p><span class="blend">Article 4 of Web App Tutorial - We add a view page to the Bed Nap app and look at how request URL information is converted into meaningful objects. 
   </span></p></a></article></li><li><article><a href="/articles/fantom-for-beginners"><h4><span class="blend"><span class="title">Fantom For Beginners</span><span class="text-muted nowrap"> - 30th Aug 2014 </span></span></h4><p><span class="blend">7 Articles - A guide for beginners wanting to learn the fundamentals of the Fantom Programming Language. 
   </span></p></a></article></li></ul></div></div></div><style>.feature img:hover {
   	filter:			url(#css-glow-15);
   	-webkit-filter:	drop-shadow(0 0 15px #20EE23);
   }
   </style></main><footer id="fatFooter" class="clearfix hidden-print"><div class="container"><div id="ff-google" class="row"><div class="col-sm-6"><div class="google"><div class="g-page" data-width="350" data-href="//plus.google.com/+FantomFactoryOrgy" data-theme="dark" data-layout="landscape" data-rel="publisher"></div></div></div><div class="col-sm-6 right"><div class="google"><div class="g-community" data-width="350" data-href="//plus.google.com/communities/108121220239226647550" data-layout="landscape" data-theme="dark"></div></div></div></div><div class="row"><div class="col-sm-6"><div id="addThis"><div class="shareTheJoy">If you like this page, then share the joy!</div><div class="addthis_toolbox addthis_default_style addthis_32x32_style"><a class="addthis_button_preferred_1"></a><a class="addthis_button_preferred_2"></a><a class="addthis_button_preferred_3"></a><a class="addthis_button_preferred_4"></a><a class="addthis_button_compact"></a><a class="addthis_counter addthis_bubble_style"></a></div></div></div><div class="col-sm-6 right">© 2013-2014 <a href="http://www.alienfactory.co.uk/contact">Steve Eynon</a><br>Contact <span id="ffEmail"><a id="contactUs" href="#" data-unscramble="gro.yrotcafmotnaf@eno.motnaf">----------------------------</a></span><br>Subscribe to <a class="atomFeed" href="/feeds/all"><i class="fa fa-rss-square"></i> Fantom-Factory</a>
   
   </div></div></div></footer>
   <script type="text/javascript" src="/scripts/require-2.1.14.js"></script>
   <script type="text/javascript">requirejs.config({"baseUrl":"/modules/",
   "waitSeconds":15,
   "xhtml":false,
   "skipDataMain":true,
   "paths":{"jquery":["//code.jquery.com/jquery-2.1.1.min","/scripts/jquery-2.1.1.min"],
   "bootstrap":"/scripts/bootstrap.min",
   "iframeResizer":"/scripts/iframeResizer.min",
   "googlePlus":"https://apis.google.com/js/plusone",
   "fantomModules":"/coldFeet/9pm8hw==/modules/fantomModules"},
   "shim":{"bootstrap":["jquery"],
   "googlePlus":{"exports":"gapi"}},
   "bundles":{"fantomModules":["glow","unscramble","gridtilt","onRevealLoadScript","onReveal","loadScript"]}});</script>
   <script type="text/javascript">require(["jquery"], function (\$) {
   \$( document ).ready(function() {
   	\$("[data-ga-category][data-ga-label]").on('click', function() {
   		var category = \$(this).attr("data-ga-category");
   		var label = \$(this).attr("data-ga-label");
   		if (typeof ga != 'undefined')
   		    ga('send', 'event', category, 'click', label);
   	});
   });
   });</script>
   <script type="text/javascript">require(["glow"], function (module) { });</script>
   <script type="text/javascript">require(["bootstrap"], function (module) { });</script>
   <script type="text/javascript">require(["onReveal", "unscramble"], function (onReveal, unscramble) {
   onReveal('#contactUs', function() { unscramble('contactUs'); })
   });</script>
   <script type="text/javascript">window.___gcfg = { lang: 'en-GB', parsetags: 'explicit' };</script>
   <script type="text/javascript">require(["onReveal", "googlePlus"], function (onReveal, gapi) {
   onReveal('#contactUs', function() { gapi.page.go('ff-google'); gapi.community.go('ff-google'); })
   });</script>
   <script type="text/javascript">var addthis_config = {"data_ga_property":"UA-33997125-4",
   "data_track_addressbar":true,
   "data_ga_social":true};</script>
   <script type="text/javascript">require(["onRevealLoadScript"], function (module) {
   module("#addThis", "//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-52be0f74452cef3f");
   });</script>
   </body></html>"""
	
}
