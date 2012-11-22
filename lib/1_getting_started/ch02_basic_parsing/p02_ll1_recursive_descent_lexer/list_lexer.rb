module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      class ListLexer
        def initialize(input)
          @input = input
        end

        def each(&block)
          switch_to_mode(:normal)

          @input.chars.each do |char|
            match_result =
              catch :state_changed do
                match(char, &block)
              end

            redo if match_result == :state_changed
          end

          finish(&block)
        end

        private

        def match_normal(char, &block)
          case char
          when "["
            yield(lbrack: char)
          when ","
            yield(comma: char)
          when "]"
            yield(rbrack: char)
          when "a".."z"
            switch_to_mode(:name)
            @name = char
          end
        end

        def match_name(char, &block)
          case char
          when "a".."z"
            @name << char
          else
            yield(name: @name)
            switch_to_mode(:normal)
            throw(:state_changed, :state_changed)
          end
        end

        def finish_normal(&block)
          yield(eof: nil)
        end

        def finish_name(&block)
          yield(name: @name)
          yield(eof: nil)
        end

        # This is an insane way to implement the State pattern, but I've left it in purely
        # because it's so ridiculous, and this is only the first pattern in the book
        def switch_to_mode(mode)
          singleton_class.send(:alias_method, :match, :"match_#{mode}")
          singleton_class.send(:alias_method, :finish, :"finish_#{mode}")
        end
      end
    end
  end
end