# frozen_string_literal: true

require 'multi_json'
require 'tempfile'
require 'stringio'

begin
  # Load the precompiled binary matching the current Ruby, if this is a
  # platform-specific gem packaged by cibuildgem.
  require "jq/#{RUBY_VERSION[/\d+\.\d+/]}/jq_core"
rescue LoadError
  # Fall back to the extension compiled from source at install time.
  require 'jq/jq_core'
end
require 'jq/version'
require 'jq/parser'

def JQ(src, parse_json: true) # rubocop:disable Naming/MethodName
  JQ::Parser.new(src, parse_json: parse_json)
end
