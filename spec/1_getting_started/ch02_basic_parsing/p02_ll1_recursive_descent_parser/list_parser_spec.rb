require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_parser/list_parser'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentParser
      describe ListParser do
        let(:lexer) { mock(LL1RecursiveDescentLexer::ListLexer, each: tokens.each) }

        subject(:parser) { ListParser.new(lexer) }

        context "no list" do
          let(:tokens) {
            [
              { eof: nil }
            ]
          }

          specify {
            expect(parser.list).to be_nil
          }
        end
      end
    end
  end
end