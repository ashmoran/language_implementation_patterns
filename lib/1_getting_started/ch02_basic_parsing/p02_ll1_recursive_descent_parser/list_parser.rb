module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentParser
      class ListParser
        def initialize(lexer)
          @tokens = lexer.each
          @lookahead = @tokens.peek
        end

        def list
          [ ].tap do |collected_list|
            match(:lbrack)
            elements(collected_list)
            match(:rbrack)
          end
        end

        def elements(collected_list)
          element(collected_list)
          while type(@lookahead) == :comma
            match(:comma)
            element(collected_list)
          end
        end

        def element(collected_list)
          case type(@lookahead)
          when :name
            collected_list << text(@lookahead).to_sym
            match(:name)
          end
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
          @tokens.next
          @lookahead = @tokens.peek
        end

        def type(token)
          token.keys.first
        end

        def text(token)
          token.values.first
        end
      end
    end
  end
end