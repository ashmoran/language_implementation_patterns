module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      class ListLexer
        def initialize(input)
          @input = input
        end

        def each(&block)
          [ { eof: nil } ].each(&block)
        end
      end
    end
  end
end