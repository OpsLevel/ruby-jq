# frozen_string_literal: true

require 'jq'

module JQ
  module Extend
    def jq(program, &block)
      src = MultiJSON.generate(self)
      JQ(src).search(program, &block)
    end
  end
end

class Hash;  include JQ::Extend; end
class Array; include JQ::Extend; end
