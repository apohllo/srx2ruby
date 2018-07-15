#!/usr/bin/env ruby
# encoding: utf-8
require 'rexml/document'
require 'pp'
require 'slop'
include REXML

begin
  opts = Slop.parse do |o|
    o.separator 'Convert SRX rules file to runnable Ruby library.'
    o.separator 'Options:'
    o.string '-f', '--input', 'file with SRX segmentation rules', required: true
    o.string '-l', '--language', 'the name of the Ruby module (inside SRX) as well as the output files'
    o.string '-o', '--output', 'output directory (current directory by default)', default: '.'
    o.array '-r', '--ruleset', 'selected language rules (multiple rulesets allowed)'
    o.on '-h', '--help', 'print help' do puts o; exit; end
  end
rescue Slop::Error => ex
  puts ex
  exit
end

xml = nil
File.open(opts[:input]) do |input|
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
  next unless opts[:language].include?(language.attributes['languagerulename'])
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
    rescue RegexpError, ArgumentError => ex
      puts "Error: #{ex}"
      puts rule.to_s
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
puts "Breaking/nonbreaking/errors #{breaking_rules}/#{nonbreaking_rules}/#{invalid_rules}"

capitalized_language = opts[:language][0].upcase + opts[:language][1..-1].downcase
downcase_language = opts[:language].downcase

File.open("#{opts[:output]}/#{downcase_language}-rules.rb","w") do |out|
  out.puts <<-END
module SRX
  module #{capitalized_language}
    module Rules
      def rules
        @@rules ||=
  END

  PP.pp(CONSOLIDATED_RULES,out)

  out.puts <<-END
      end
    end
  end
end
  END
end

File.open("#{opts[:output]}/srx-#{downcase_language}.rb","w") do |out|
  template = File.read(File.dirname(__FILE__) + "/srx-template.rb")
  out.puts template.
    sub(/^# REQUIRE/m, "require_relative '#{downcase_language}-rules'").
    sub(/^# MODULE-START/m, "  module #{capitalized_language}\n    extend Rules").
    sub(/^# MODULE-END/m, "  end")
end
