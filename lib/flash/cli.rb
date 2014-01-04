require 'flash'
require 'flash/runner'
require 'optparse'
require 'pathname'

class Flash::CLI

  def self.start
    options = {}
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: run [options] group"

      opts.on("-c", "--command command", String, "Commands to run (semicolon separated)") do |command|
        options[:commands] = command.split(';').map(&:strip)
      end

      opts.on("-d", "--debug", "Debug: print each command result") do |d|
        options[:debug] = d
      end

      opts.on("-r", "--recipe recipe", "Run registered recipe if present") do |recipe|
        options[:recipe] = recipe
      end

      opts.on("-l", "--list-recipes", "List registered recipes") do |l|
        options[:list_recipes] = l
      end

      opts.on("-h", "--help", "Help documentation") do
        puts opts ; exit
      end

      opts
    end
    optparse.parse!

    if ARGV.empty?
      puts "Group name is missing."
      puts optparse ; exit
    end

    group = ARGV[0]
    Flash::Runner.new(options, group).start
  end
end
