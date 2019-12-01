#!/usr/bin/env ruby
require 'find'
require 'nokogiri'

# finds all ColourIds declared in the juce source code
juce_dir = File.join Dir.pwd, "JUCE", "modules"

results = {}

def parse_class(lines)

end
Find.find(juce_dir) do |path|
  next unless FileTest.file?(path) &&  File.extname(path) == ".h"
  lines = File.readlines(path)
  klass = ''
  lastm = ''
  id = ''
  value = ''
  comment = ''
  _klass = ''
  lines.each do |line|
    line.match(/^\s*?class\s+?(?:JUCE_API\s+?)?(.*)[^:]:[^:]/) do |m|
      lastm = m.inspect
      _klass = m[1].chomp('').strip.split(/\s/).last.gsub(/[^a-zA-Z0-9]/, '')
      if _klass.empty?
        klass = "ColourIds"
      else
        klass = "#{_klass}::ColourIds"
      end

      if results.key?(klass) && results[klass].length > 0
        $stderr.puts "duplicate definition of #{klass} from path=#{path}"
      end
    end

    if line =~ /enum ColourIds/ .. line =~ /};/
      if line =~ /enum ColourIds/
        id = ''
        value = ''
        comment = ''
      end

      if line =~/{/ .. line =~/}/
        line.match(/\b([[:lower:]]\w+?Id)\b/) do |m|
          if id != "" && value != ""
            results[klass] ||= []
            results[klass].push([id, value, comment])
          end
          id = m[1]
          value = ''
          comment = ''
        end

        line.match(/\=\s+(0x\h*)/) do |m|
          value = m[1]
        end

        if line =~/\/\*/ .. line =~/\*\//
          line.gsub!(/^.*\/\*\*?/, '')
          line.gsub!(/\*\/.*/, '')
          line.gsub!(/</, '')
          line.strip!
          line.chomp!
          comment += line
        end
      end

    end
  end
end


builder = Nokogiri::XML::Builder.new do |xml|
  xml.klasses {
    results.sort{|a,b| a[0] <=> b[0]}.each do |klass,ids|
      #v = results[k]
      #puts "#{k}"
      xml.klass(name: klass) {
        ids.sort{|a,b| a[0] <=> b[0]}.each do |name, id, comment|
          xml.colour_id(name: name, id: id, comment: comment)
        end
      }
    end
  }
end
puts builder.to_xml
