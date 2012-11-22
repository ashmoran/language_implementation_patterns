module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      class ListLexer
        def initialize(input)
          @input = input
        end

        def each(&block)
          singleton_class.send(:alias_method, :match, :match_normal)
          singleton_class.send(:alias_method, :finish, :finish_normal)

          @input.chars.each do |char|
            match(char, &block)
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
            singleton_class.send(:alias_method, :match, :match_name)
            singleton_class.send(:alias_method, :finish, :finish_name)
            @name = char
          end
        end

        def match_name(char)
          @name << char
          # singleton_class.send(:alias_method, :match, :match_normal)
        end

        def finish_normal(&block)
          yield(eof: nil)
        end

        def finish_name(&block)
          yield(name: @name)
          yield(eof: nil)
        end
      end
    end
  end
end