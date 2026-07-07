# frozen_string_literal: true

require 'mkmf'

def using_system_libraries?
  arg_config('--use-system-libraries', ENV.key?('RUBYJQ_USE_SYSTEM_LIBRARIES'))
end

unless using_system_libraries?
  message "Building jq using packaged libraries.\n"

  require 'rubygems'
  require 'mini_portile2'

  onigmo = MiniPortile.new('onigmo', '6.2.0')
  onigmo.files = ['https://github.com/k-takata/Onigmo/releases/download/Onigmo-6.2.0/onigmo-6.2.0.tar.gz']
  onigmo.configure_options = [
    '--disable-shared',
    '--enable-static',
    '--with-pic'
  ]
  onigmo.cook

  # OpsLevel fork of jq: `env`/`$ENV` always return an empty object.
  recipe = MiniPortile.new('jq', '1.6.opslevel')
  recipe.files = ['https://github.com/OpsLevel/jq/archive/845f4206dd8a82355325bafffbb54a5155cf67ec.tar.gz']
  recipe.configure_options = [
    '--disable-maintainer-mode',
    '--disable-docs',
    '--disable-shared',
    '--enable-static',
    '--with-pic',
    "--with-oniguruma=#{onigmo.path}"
  ]
  class << recipe
    def configure
      execute('autoreconf', 'autoreconf -i')
      super
    end
  end
  recipe.cook
  recipe.activate
  $LIBPATH = ["#{recipe.path}/lib", "#{onigmo.path}/lib"] | $LIBPATH # rubocop:disable Style/GlobalVars
  $CPPFLAGS << " -I#{recipe.path}/include" # rubocop:disable Style/GlobalVars

  abort 'libonigmo not found' unless have_library('onigmo')
end

abort 'libjq not found' unless have_library('jq')

create_makefile('jq/jq_core')
