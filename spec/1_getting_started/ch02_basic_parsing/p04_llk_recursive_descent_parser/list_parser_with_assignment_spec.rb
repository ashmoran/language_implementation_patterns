require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p04_llk_recursive_descent_parser/list_parser_with_assignment'
require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require_relative '../p03_ll1_recursive_descent_parser/list_parser_contract'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentParser
      describe "Intergration:", ListParserWithAssignment, "and lexer" do
        let(:input) { "[ a, [ x, [ i, j ] ], b ]" }

        let(:lexer) { LL1RecursiveDescentLexer::ListLexer.new(input) }

        subject(:parser) { ListParserWithAssignment.new(lexer) }

        it "parses lists with assignments" do
          pending "not sure if  we need an integration test here yet or not"
          expect(parser.list).to be == [ :a, [ :x, [ :i, :j ] ], :b ]
        end
      end

      describe ListParserWithAssignment do
        it_behaves_like "a ListParser"

        let(:tokens) {
          LL1RecursiveDescentLexer::Token.descriptions_to_tokens(token_descriptions)
        }
        let(:lexer) { mock(LL1RecursiveDescentLexer::ListLexer, each: tokens.each) }

        subject(:parser) { ListParserWithAssignment.new(lexer) }

        it "parses assignments" do
          pending
        end
      end
    end
  end
end