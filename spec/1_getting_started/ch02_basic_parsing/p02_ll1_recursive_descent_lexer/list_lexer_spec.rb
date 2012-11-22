require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      describe ListLexer do
        subject(:lexer) { ListLexer.new(input) }

        context "empty string" do
          let(:input) { "" }
          let(:output) { [ ] }

          specify {
            lexer.each do |token|
              output << token
            end
            expect(output).to be == [
              { eof: nil }
            ]
          }
        end
      end
    end
  end
end