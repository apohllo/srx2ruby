# srx2ruby

* https://github.com/apohllo/srx2ruby

## DESCRIPTION

'srx2ruby' is a script changing SRX rules for breaking sentences into
runnable Ruby code.

## FEATURES/PROBLEMS

* this code "should work" but is not 100% SRX compliant
* some optimisations are present, but don't expect highest performance
* language selection rules are not SRX compliant

## INSTALL

Standard installation from rubygems:

```
gem install srx2ruby
```

## BASIC USAGE

Invoke the script with the following parameters:

```
srx2ruby -f rules.srx [-o path] -l Language -r LanguageRuleSet1 [-r LanguageRuleSet2...]
```

For instance:

```
srx2ruby -f segment.srx -l Polish -r Polish -r ByLineBreak
```

`-h` flag gives you help with full description of the options:

```
srx2ruby -h
```

Example rules for some languages (including English) are available on LanguageTool site:

  * [segment.srx](https://raw.githubusercontent.com/languagetool-org/languagetool/master/languagetool-core/src/main/resources/org/languagetool/resource/segment.srx)

## AVAILABLE GEMS

There are the following gems available with generated rules:

* [srx-polish](https://github.com/apohllo/srx-polish)
* [srx-english](https://github.com/apohllo/srx-english)

## LICENSE

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

## FEEDBACK

* mailto:apohllo@o2.pl
