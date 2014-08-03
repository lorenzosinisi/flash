if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'

  if ENV['TRAVIS']
    require 'coveralls'
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end

  SimpleCov.start do
    add_filter '/spec'
    add_filter '/vendor'
  end
end

require 'rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

RSpec.configure do |config|
  config.color = true
  config.order = 'rand'
end

def flash(args)
  capture_stdout do
    begin
      Flash::CLI.new(args.split(' ')).start
    rescue SystemExit
      nil
    end
  end
end

def make_pipe
  IO.method(:pipe).arity.zero? ? IO.pipe : IO.pipe('BINARY')
end

def capture_stdout
  old_stdout = $stdout.dup
  rd, wr = make_pipe
  $stdout = wr
  yield
  wr.close
  rd.read
ensure
  $stdout = old_stdout
end