module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentParser
      class ListParser
        def initialize(lexer)
          @tokens = lexer.each
          @lookahead = @tokens.next
        end

        def list
          match(:lbrack)
          match(:rbrack)
          [ ]
        end

        private

        def match(expected_type)
          if type(@lookahead) == expected_type
            consume
          else
            raise ArgumentError.new(
              "Expected #{expected_type.inspect}, found #{type(@lookahead).inspect}"
            )
          end
        end

        def consume
          @lookahead = @tokens.next
        end

        def type(token)
          token.keys.first
        end
      end
    end
  end
end