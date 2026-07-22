# ruby-jq

Ruby bindings for jq.

see [http://stedolan.github.io/jq/](http://stedolan.github.io/jq/).

[![Gem Version](https://badge.fury.io/rb/ruby-jq.svg)](http://badge.fury.io/rb/ruby-jq)

## Precompiled binaries

Precompiled platform gems are published for `x86_64-linux` and `arm64-darwin`
(one binary per supported minor Ruby version), so installing on those platforms
requires no compiler or build tools. They are built and released with
[cibuildgem](https://github.com/Shopify/cibuildgem) via the
`.github/workflows/cibuildgem.yaml` workflow.

On other platforms the source gem is installed instead: it downloads and
statically compiles [OpsLevel's fork of jq](https://github.com/OpsLevel/jq)
(jq 1.6 lineage where `env`/`$ENV` always return an empty object) along with
[Onigmo](https://github.com/k-takata/Onigmo) for regex support, so the built
extension is self-contained. Building from source requires autoconf, automake,
and libtool.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-jq'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-jq

### Using system libraries

By default, ruby-jq downloads and compiles its own version of libjq. If you
would like to use your own version of libjq, you can skip this process by
passing the `--use-system-libraries` flag to `gem install`, or by setting the
`RUBYJQ_USE_SYSTEM_LIBRARIES` env var.

## Usage

```ruby
require 'jq'

src = <<EOS
[
  "FOO",
  {
    "BAR": [100, 200]
  },
  1.23,
  [1, "2", 3]
]
EOS

jq = JQ(src)

jq.search('.[]') do |value|
  p value
  # => "FOO"
  # => {"BAR"=>[100, 200]}
  # => 1.23
  # => [1, "2", 3]
end

p jq.search('.[]')
# => ["FOO", {"BAR"=>[100, 200]}, 1.23, [1, "2", 3]]

jq = JQ(src, parse_json: false)

jq.search('.[1].BAR') do |value|
  p value
  # => "[100,200]"
end
```

### Query for Hash/Array

```ruby
require 'jq/extend'

p {'FOO' => 100, 'BAR' => [200, 200]}.jq('.BAR[]')
# => [200, 200]

['FOO', 100, 'BAR', [200, 200]].jq('.[3][]') do |value|
  p value
  # => 200
end
```
