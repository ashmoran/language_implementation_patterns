require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require '1_getting_started/ch02_basic_parsing/p04_llk_recursive_descent_parser/lexer_lookahead'
require_relative '../p02_ll1_recursive_descent_lexer/list_lexer_contract'

module GettingStarted
  module BasicParsing
    module LLkRecursiveDescentParser
      shared_examples_for "LexerLookahead#peek" do
        let(:input) { "[ a = b ]" }

        example do
          expect(lexer.peek.value).to be == "["
        end

        example do
          expect(lexer.peek(1).value).to be == "["
        end

        example do
          expect(lexer.peek(2).value).to be == "a"
        end

        example do
          expect(lexer.peek(5).value).to be == "]"
        end

        example do
          expect(lexer.peek(6).to_hash).to be == { eof: nil }
        end

        example do
          expect { lexer.peek(7) }.to raise_error(StopIteration)
        end
      end

      describe LexerLookahead do
        describe "lookahead" do
          let(:tokens) {
            LL1RecursiveDescentLexer::Token.descriptions_to_tokens(
              [
                { lbrack: "[" },
                { name:   "a" },
                { equals: "=" },
                { name:   "b" },
                { rbrack: "]" },
                { eof:    nil }
              ]
            )
          }

          let(:underlying_lexer) { tokens.each }

          subject(:lexer) { LexerLookahead.new(underlying_lexer) }

          describe "#peek" do
            it_behaves_like "LexerLookahead#peek"
          end
        end

        context "wrapping a ListLexer" do
          let(:underlying_lexer) { LL1RecursiveDescentLexer::ListLexer.new(input) }
          subject(:lexer) { LexerLookahead.new(underlying_lexer) }

          let(:collected_output) { [ ] }
          let(:output) {
            collected_output.map { |token| token.to_hash }
          }

          it_behaves_like "a ListLexer"

          describe "#peek" do
            it_behaves_like "LexerLookahead#peek"
          end
        end
      end
    end
  end
end