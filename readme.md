## Overview 

*HTML Parser is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

A valiant effort to parse valid HTML5 documents into XML as defined by [W3C HTML Syntax](http://www.w3.org/html/wg/drafts/html/CR/syntax.html#syntax).

`Html Parser` currently recognises and supports:

Elements:

- Normal elements: `<div></div>`
- Void elements: `<br>`
- Self closing elements: `<foreignElement />`
- Raw text elements: `<script> ... </script>`
- Escapable raw text elements: `<textarea> ... </textarea>`

Attributes:

- Empty attributes: `<input disabled>`
- Unquoted attributes: `<input type=submit>`
- Single quoted attributes: <input type='submit'>
- Double quoted attributes: `<input type="submit">`

Other:

- XML declarations: `<?xml version="1.0" ?>`
- DocTypes: `<!DOCTYPE html >`
- Comments: `<!-- comment -->`
- CData Sections: `<![CDATA[ cdata ]]>`
- Numerical character references: `&#160;` and `&#xA0;`

> "Html Parser" because only *Chuck Norris* can parse HTML with regular expressions.

## Install 

Install `HTML Parser` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afHtmlParser

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afHtmlParser 0.0+"]

## Documentation 

Full API & fandocs are available on the [Status302 repository](http://repo.status302.com/doc/afHtmlParser/).

## Quick Start 

```
class Example {
    Void main() {
        elem := HtmlParser().parseDoc("<input disabled value=wotever>")
        
        echo(elem.writeToStr)   // --> <input disabled='disabled' value='wotever'/>
    }
}
```

## Usage 

1 class - 1 method - 1 argument - 1 return value. It's pretty self explanatory!

While `Html Parser` is more lenient than a validator it does *NOT* attempt to reconstruct documents from the tag soup of badly formatted HTML4 documents.

It's main purpose is to parse HTML5 documents created with [Slim](http://www.fantomfactory.org/pods/afSlim) into XML so they may be tested by [Bounce](http://www.fantomfactory.org/pods/afBounce) and [Sizzle](http://www.fantomfactory.org/pods/afSizzle).

`Html Parser` uses [Pegger](http://www.fantomfactory.org/pods/afPegger) because [HTML can not be parsed with regular expressions](http://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/1732454#1732454).

