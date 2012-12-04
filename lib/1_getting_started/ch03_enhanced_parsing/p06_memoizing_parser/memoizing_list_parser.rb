require '1_getting_started/errors'

# UNFINISHED!!!
#
# I got bored of this - it's a big refactoring for a relatively minor change,
# and I'm not primarily concerned with how to implement parsers. But I've left
# the unfunished code here in case I decide to return to it some time.
# It passes all the tests :)

module GettingStarted
  module EnhancedParsing
    module MemoizingParser

      class MemoizingListParser
        def initialize(replayable_lexer)
          @lexer = replayable_lexer
        end

        def stat
          if speculate_stat_list
            stat_list
          elsif speculate_stat_parallel_assigment
            stat_parallel_assignment
          else
            raise NoViableAlternativeError.new("Expecting <list> or <parallel assignment>")
          end
        end

        def speculate_stat_list
          @lexer.speculate do
            stat_list
          end
        rescue RecognitionError => e
          false
        end

        def speculate_stat_parallel_assigment
          @lexer.speculate do
            stat_parallel_assignment
          end
        rescue RecognitionError => e
          false
        end

        def stat_list
          matched_list = list
          match(:eof)
          matched_list
        end

        def stat_parallel_assignment
          matched_parallel_assigment = parallel_assignment
          match(:eof)
          matched_parallel_assigment
        end

        def list
          failed = false

          @lexer.if_speculating do
            return if already_parsed?(:list)
          end

          parsed_list = _list

          @lexer.if_speculating do
            memoize(:list, parsed_list)
          end

          parsed_list
        rescue RecognitionError => e
          @lexer.if_speculating do
            memoize_failure(:list)
          end

          raise
        end

        def _list
          [ ].tap do |collected_list|
            match(:lbrack)
            elements(collected_list)
            match(:rbrack)
          end
        end

        def parallel_assignment
          lhs = list
          match(:equals)
          rhs = list
          { lhs => rhs }
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

        def already_parsed?(expression_type)
          false
        end

        def memoize(expression_type, expression)
          expression
        end

        def memoize_failure(expression_type)
          nil
        end

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
