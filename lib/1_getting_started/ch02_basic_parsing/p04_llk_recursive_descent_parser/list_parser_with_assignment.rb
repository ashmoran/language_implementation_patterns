module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentParser
      class ListParserWithAssignment
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
            raise ArgumentError.new(
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
            raise ArgumentError.new(
              "Expected :name or :lbrack, found #{@lookahead.type.inspect}"
            )
          end
        end

        private

        def match(expected_type)
          if @lookahead.type == expected_type
            consume
          else
            raise ArgumentError.new(
              "Expected #{expected_type.inspect}, found #{@lookahead.type.inspect}"
            )
          end
        end

        def consume
          @tokens.next
          @lookahead = @tokens.peek
        end
      end
    end
  end
end