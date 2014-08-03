require 'flash'
require 'flash/command/base'
require 'pathname'

class Flash::Command::Run < Flash::Command::Base
  attr_accessor :color
  attr_accessor :project

  def initialize(command, group)
    @command = command
    @group = group
  end

  def execute
    raise(ArgumentError, 'Missing required command and group parameters.') unless @command && @group

    unknown_group_and_exit(@group) unless valid_group?(@group)
    run_command_in_group(@command, @group)
  end

  private

  def unknown_group_and_exit(group)
    puts "Unknown group \"#{group}\" in .flash.yml config."
    exit 1
  end

  def run_command_in_group(command, group)
    projects(group).each do |project|
      change_color!
      self.project = project

      run("cd #{ project_dir }", verbose: false)
      commands(command).each { |cmd| run(cmd) }

      say ''
    end
  end

  def projects(group)
    config[group]
  end

  def run(command, options = {})
    verbose = options[:verbose] || true

    prompt command if verbose
    system "cd #{ project_dir } ; #{ command }"
  end

  def commands(alias_or_command)
    commands = aliases[alias_or_command] || alias_or_command
    commands.split(';').map(&:strip)
  end

  def aliases
    config['aliases'] || {}
  end

  def prompt(message)
    say "#{ project }> #{ message }"
  end

  def say(stuff)
    prefix = "\e[38;5;#{ color }m"
    suffix = "\e[0m"
    system "echo '#{ prefix }#{ stuff }#{ suffix }'"
  end

  def change_color!
    self.color = rand((1..22)) * 10 + 2
  end

  def project_dir
    "#{ Dir.pwd }/#{ project }"
  end
end
