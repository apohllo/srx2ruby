== srx2ruby

* https://github.com/apohllo/srx2ruby

= DESCRIPTION

'srx2ruby' is a script changing SRX rules for breaking sentences into
runnable Ruby code.

= FEATURES/PROBLEMS

* this code "should work" but is not 100% SRX compliant
* some optimisations are present, but don't expect highest performance
* language selection rules are not SRX compliant

= INSTALL

Standard installation from rubygems:

  $ gem install srx2ruby

== BASIC USAGE

Invoke the script with the following parameters:

  $ srx2ruby rules.srx output.rb LanguageRuleSet1 [LanguageRuleSet2...]

For instance:

  $ srx2ruby segment.srx srx-polish.rb Polish ByLineBreak

Example rules for some languages (including English) are available on Marcin
Mikłowski's site:

  * http://morfologik.blogspot.com/2009/11/talking-about-srx-in-lt-during-ltc.html

== LICENSE

(The MIT License)

Copyright (c) 2011 Aleksander Pohl

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

== FEEDBACK

* mailto:apohllo@o2.pl
