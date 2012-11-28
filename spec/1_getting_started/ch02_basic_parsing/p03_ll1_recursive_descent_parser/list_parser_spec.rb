require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p03_ll1_recursive_descent_parser/list_parser'
require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require_relative 'list_parser_contract'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentParser
      describe "Intergration:", ListParser, "and lexer" do
        let(:input) { "[ a, [ x, [ i, j ] ], b ]" }

        let(:lexer) { LL1RecursiveDescentLexer::ListLexer.new(input) }

        subject(:parser) { ListParser.new(lexer) }

        it "parses lists!" do
          expect(parser.list).to be == [ :a, [ :x, [ :i, :j ] ], :b ]
        end
      end

      describe ListParser do
        it_behaves_like "a ListParser"

        let(:tokens) {
          LL1RecursiveDescentLexer::Token.descriptions_to_tokens(token_descriptions)
        }
        let(:lexer) { tokens.each }

        subject(:parser) { ListParser.new(lexer) }
      end
    end
  end
end