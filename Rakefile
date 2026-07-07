# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/extensiontask'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new('spec')

Rake::ExtensionTask.new('jq_core') do |ext|
  ext.ext_dir = 'ext'
  ext.lib_dir = 'lib/jq'
  ext.cross_compiling do |spec|
    # Platform gems ship precompiled binaries and never build from source.
    spec.dependencies.reject! { |dep| dep.name == 'mini_portile2' }
  end
end

RuboCop::RakeTask.new do |task|
  task.options = %w[-c .rubocop.yml]
end

task default: %i[compile rubocop spec]
