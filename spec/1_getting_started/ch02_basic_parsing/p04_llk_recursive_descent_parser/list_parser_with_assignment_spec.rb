require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p04_llk_recursive_descent_parser/list_parser_with_assignment'
require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require_relative '../p03_ll1_recursive_descent_parser/list_parser_contract'

module GettingStarted
  module BasicParsing
    module LLkRecursiveDescentParser
      describe "Intergration:", ListParserWithAssignment, "and lexer" do
        let(:input) { "[ a = b ]" }

        let(:lexer) { LL1RecursiveDescentLexer::ListLexer.new(input) }
        let(:lookahead) { LexerLookahead.new(lexer) }
        subject(:parser) { ListParserWithAssignment.new(lookahead) }

        it "parses lists with assignments" do
          expect(parser.list).to be == [ { :a => :b } ]
        end
      end

      describe ListParserWithAssignment do
        let(:tokens) {
          LL1RecursiveDescentLexer::Token.descriptions_to_tokens(token_descriptions)
        }
        let(:lexer) { tokens.each }
        let(:lookahead) { LexerLookahead.new(lexer) }
        subject(:parser) { ListParserWithAssignment.new(lookahead) }

        it_behaves_like "a ListParser"

        context "list with assignment" do
          let(:token_descriptions) {
            [
              { lbrack: "[" },
              { name:   "a" },
              { equals: "=" },
              { name:   "b" },
              { rbrack: "]" },
              { eof:    nil }
            ]
          }

          specify {
            expect(parser.list).to be == [ { :a => :b } ]
          }
        end
      end
    end
  end
end