module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentParser

      # Implements Pattern 2: LL(1) Recursive-Descent Lexer
      #
      # Two major differences from the book examples:
      #
      # * We turn the tokens into a Ruby array (ie we do something with them
      #   other than detect errors). This is pretty easy as we just need a
      #   Collecting Parameter.
      #
      # * We handle the empty list case. I didn't notice this was excluded
      #   from the grammar, but the discussion on p40 hints at why. Turns out
      #   even in this simple case it's much harder to parse optional elements,
      #   as it means we have to treat the first element of a list differently
      #   (because "[ ]" is valid but "[ a, ]" is not, which is what a naive
      #   parser gives you).
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
          first_element(collected_list)
          while type(@lookahead) == :comma
            match(:comma)
            element(collected_list)
          end
        end

        def first_element(collected_list)
          case type(@lookahead)
          when :name, :lbrack
            element(collected_list)
          when :rbrack
            return
          else
            raise ArgumentError.new(
              "Expected :lbrack, :name or :rbrack, found #{type(@lookahead).inspect}"
            )
          end
        end

        def element(collected_list)
          case type(@lookahead)
          when :name
            collected_list << text(@lookahead).to_sym
            match(:name)
          when :lbrack
            collected_list << list
          else
            raise ArgumentError.new(
              "Expected :name or :lbrack, found #{type(@lookahead).inspect}"
            )
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