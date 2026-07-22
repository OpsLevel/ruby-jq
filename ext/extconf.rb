# frozen_string_literal: true

require 'mkmf'

def using_system_libraries?
  arg_config('--use-system-libraries', ENV.key?('RUBYJQ_USE_SYSTEM_LIBRARIES'))
end

unless using_system_libraries?
  message "Building jq using packaged libraries.\n"

  require 'rubygems'
  gem 'mini_portile2', '~> 2.2'
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
    "--with-oniguruma=#{onigmo.path}",
    # macOS declares lgamma_r only under _REENTRANT; jq's configure detects
    # the symbol via a link check, so compilation fails without this.
    'CPPFLAGS=-D_REENTRANT'
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

# On ELF platforms, keep the statically linked jq/Onigmo symbols out of the
# extension's dynamic symbol table: libruby exports its own onig_* functions,
# and the flat ELF namespace would let calls bind across copies. (Mach-O uses
# two-level namespaces, and its linker lacks this flag.)
$LDFLAGS << ' -Wl,--exclude-libs,ALL' unless RUBY_PLATFORM.include?('darwin') # rubocop:disable Style/GlobalVars

create_makefile('jq/jq_core')
