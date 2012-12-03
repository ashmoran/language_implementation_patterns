module GettingStarted
  module EnhancedParsing
    module BacktrackingParser
      class NoViableAlternativeError < RuntimeError; end
      class RecognitionError < ArgumentError; end

      class ListParserWithParallelAssignment
        def initialize(replayable_lexer)
          @lexer = replayable_lexer
        end

        def stat
          if speculate_stat_list
            matched_list = list
            match(:eof)
            matched_list
          elsif speculate_stat_parallel_assigment
            matched_parallel_assigment = parallel_assignment
            match(:eof)
            matched_parallel_assigment
          else
            raise NoViableAlternativeError.new("Expecting <list> or <parallel assignment>")
          end
        end

        def speculate_stat_list
          @lexer.speculate do
            list
            match(:eof)
          end
        rescue ArgumentError => e
          false
        end

        def speculate_stat_parallel_assigment
          @lexer.speculate do
            parallel_assignment
            match(:eof)
          end
        rescue ArgumentError => e
          false
        end

        def list
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
            raise ArgumentError.new(
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
            raise ArgumentError.new(
              "Expected :name or :lbrack, found #{@lexer.peek.inspect}"
            )
          end
        end

        private

        def match(expected_type)
          if @lexer.peek.type == expected_type
            consume
          else
            raise ArgumentError.new(
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
