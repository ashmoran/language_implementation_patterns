require '1_getting_started/recognition_error'

module GettingStarted
  module BasicParsing
    module LLkRecursiveDescentParser

      # Implements Pattern 4: LL(k) Recursive-Descent Parser
      # (Needs the help of the LexerLookahead)
      #
      # Major differences from the book example:
      #
      # * I put the code for the lookahead in a separate class (the rest of
      #   the discussion is in the LexerLookahead code)
      class ListParserWithAssignment
        def initialize(lookahead_lexer)
          @lexer = lookahead_lexer
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
          while @lexer.peek.type == :comma
            match(:comma)
            element(collected_list)
          end
        end

        def first_element(collected_list)
          case @lexer.peek.type
          when :name, :lbrack
            element(collected_list)
          when :rbrack
            return
          else
            raise RecognitionError.new(
              "Expected :lbrack, :name or :rbrack, found #{@lexer.peek.inspect}"
            )
          end
        end

        def element(collected_list)
          if @lexer.peek(1).type == :name && @lexer.peek(2).type == :equals
            lhs, _, rhs = match(:name), match(:equals), match(:name)
            collected_list << { lhs.value.to_sym => rhs.value.to_sym }
          elsif @lexer.peek.type == :name
            collected_list << @lexer.peek.value.to_sym
            match(:name)
          elsif @lexer.peek.type == :lbrack
            collected_list << list
          else
            raise RecognitionError.new(
              "Expected :name or :lbrack, found #{@lexer.peek.inspect}"
            )
          end
        end

        private

        def match(expected_type)
          if @lexer.peek.type == expected_type
            consume
          else
            raise RecognitionError.new(
              "Expected #{expected_type.inspect}, found #{@lexer.peek.inspect}"
            )
          end
        end

        def consume
          @lexer.next
        end
      end

    end
  end
end