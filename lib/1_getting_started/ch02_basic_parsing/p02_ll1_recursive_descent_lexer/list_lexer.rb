module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      class ListLexer
        def initialize(input)
          @input = input
        end

        def each(&block)
          @input.chars.each do |char|
            case char
            when "["
              yield(lbrack: char)
            when ","
              yield(comma: char)
            when "]"
              yield(rbrack: char)
            when "a".."z"
              yield(name: char)
            end
          end
          yield(eof: nil)
        end
      end
    end
  end
end