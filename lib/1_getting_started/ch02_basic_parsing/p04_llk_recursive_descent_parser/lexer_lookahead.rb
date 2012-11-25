require 'forwardable'

module GettingStarted
  module BasicParsing
    module LLkRecursiveDescentParser
      class LexerLookahead
        extend Forwardable

        def_delegator :@lexer, :each

        def initialize(lexer)
          @lexer = lexer
        end
      end
    end
  end
end