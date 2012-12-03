require '1_getting_started/recognition_error'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentParser

      # Implements Pattern 3: LL(1) Recursive-Descent Parser
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
          @lexer = lexer
          @lookahead = @lexer.next
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
          while @lookahead.type == :comma
            match(:comma)
            element(collected_list)
          end
        end

        def first_element(collected_list)
          case @lookahead.type
          when :name, :lbrack
            element(collected_list)
          when :rbrack
            return
          else
            raise RecognitionError.new(
              "Expected :lbrack, :name or :rbrack, found #{@lookahead.type.inspect}"
            )
          end
        end

        def element(collected_list)
          case @lookahead.type
          when :name
            collected_list << @lookahead.value.to_sym
            match(:name)
          when :lbrack
            collected_list << list
          else
            raise RecognitionError.new(
              "Expected :name or :lbrack, found #{@lookahead.type.inspect}"
            )
          end
        end

        private

        def match(expected_type)
          if @lookahead.type == expected_type
            consume
          else
            raise RecognitionError.new(
              "Expected #{expected_type.inspect}, found #{@lookahead.type.inspect}"
            )
          end
        end

        def consume
          @lookahead = @lexer.next
        end
      end

    end
  end
end