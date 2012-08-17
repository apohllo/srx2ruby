#!/usr/bin/env ruby
# encoding: utf-8
require 'rexml/document'
require 'pp'
include REXML


if ARGV.size < 3
  puts "Usage: srx2ruby rules_file.srx output.rb LanguageRuleSet1 [LanguageRuleSet2 ...]"
  puts "rules_file.srx   - file with SRX rules"
  puts "output.rb        - the file with Ruby code implementing the breaking rules"
  puts "LanguageRuleSet* - selected language rules"
  exit
end

xml = nil
File.open(ARGV[0]) do |input|
  xml = Document.new(input)
end

breaking_rules = 0
nonbreaking_rules = 0
invalid_rules = 0
RULES = []

PAR_RE = /(^|[^\\])\((?!\?[<:i])/
GROUP_RE = /\(\?iu\)/
DASH_RE = /(\[(?:[^\]]|\\\])+)-(–(?:[^\]]|\\\])+)\]/

xml.each_element('//languagerule/') do |language|
  next unless ARGV[2..-1].include?(language.attributes['languagerulename'])
  puts language.attributes['languagerulename']
  language.each_element('rule') do |rule|
    should_break = rule.attributes['break'] == "yes"
    if should_break
      breaking_rules += 1
    else
      nonbreaking_rules += 1
    end
    before = rule.elements['beforebreak'].text
    after = rule.elements['afterbreak'].text
    begin
      [before,after].each do |item|
        next unless item
        item.gsub!(PAR_RE,"\\1(?:\\2")
        item.gsub!(GROUP_RE,"(?i)")
        item.gsub!(DASH_RE,"\\1\\2-]")
      end
      re = "(#{before})(#{after})"
      /(?:(#{before})(#{after}))/
      RULES << [before,after,should_break]
    rescue RegexpError => ex
      puts ex
      invalid_rules += 1
    end
  end
end

CONSOLIDATED_RULES = []
CONSOLIDATED_RULES << { [RULES.first[1],RULES.first[2]] => [] }
RULES.each do |rule_s,rule_e,value|
  if [rule_e,value] != CONSOLIDATED_RULES.last.keys.first
    CONSOLIDATED_RULES << { [rule_e,value] => [] }
  end
  CONSOLIDATED_RULES.last[[rule_e,value]] << rule_s
end
CONSOLIDATED_RULES.map! do |hash|
  rule_e, value = hash.keys.first
  start_rules = hash.values.first
  rule_s_union = start_rules.map do |rule_s|
    "(?:#{rule_s})"
  end.join("|")
  [rule_s_union,rule_e,value]
end
puts "Breaking/nonbreaking #{breaking_rules}/#{nonbreaking_rules}/#{invalid_rules}"

result1=<<-END
#encoding: utf-8
require 'stringio'
require 'term/ansicolor'
module SRX
  RULES =
END
result2 =<<-END
  BEFORE_RE = /(?:\#{RULES.map{|s,e,v| "(\#{s})"}.join("|")})\\Z/m
  REGEXPS = RULES.map{|s,e,v| [/(\#{s})\\Z/m,/\\A(\#{e})/m,v] }
  FIRST_CHAR = /\\A./m


  class Sentence
    attr_accessor :input
    attr_writer :debug

    def initialize(text=nil)
      if text.is_a?(String)
        @input = StringIO.new(text,"r:utf-8")
      else
        @input = text
      end
    end

    def each
      buffer_length = 10
      sentence = ""
      before_buffer = ""
      after_buffer = buffer_length.times.map{|i| @input.getc}.join("")
      matched_rule = nil
      while(!@input.eof?) do
        matched_before = BEFORE_RE.match(before_buffer)
        break_detected = false
        if matched_before
          start_index = (matched_before.size - 1).times.find do |index|
            matched_before[index+1]
          end
          if @debug
            puts "\#{before_buffer}|\#{after_buffer.gsub(/\\n/,"\\\\n")}"
          end
          REGEXPS.each do |before_re,after_re,value|
            # skip the whole match
            if before_re.match(before_buffer) && after_re.match(after_buffer)
              break_detected = true
              color = value ? :red : :green
              if @debug
                sentence << Term::ANSIColor.send(color,"<\#{before_re}:\#{after_re}>")
              end
              if value
                yield sentence
                sentence = ""
              end
              break
            end
          end
        end
        next_after = @input.getc
        before_buffer.sub!(FIRST_CHAR,"") if before_buffer.size >= buffer_length
        after_buffer.sub!(FIRST_CHAR,"")
        before_buffer << $&
        sentence << $&
        after_buffer << next_after
      end
      yield sentence + after_buffer unless sentence.empty? || after_buffer.empty?
    end
  end
end
END
File.open(ARGV[1],"w") do |out|
  out.puts(result1)
  PP.pp(CONSOLIDATED_RULES,out)
  out.puts(result2)
end
