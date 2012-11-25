require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require '1_getting_started/ch02_basic_parsing/p04_llk_recursive_descent_parser/lexer_lookahead'

module GettingStarted
  module BasicParsing
    module LLkRecursiveDescentParser
      describe LexerLookahead do
        describe "lookahead" do
          it "does something" do
            pending
          end
        end

        context "wrapping a ListLexer" do
          let(:underlying_lexer) { LL1RecursiveDescentLexer::ListLexer.new(input) }
          subject(:lexer) { LexerLookahead.new(underlying_lexer) }

          let(:collected_output) { [ ] }
          let(:output) {
            collected_output.map { |token| token.to_hash }
          }

          def tokenize_all_input
            lexer.each do |token|
              collected_output << token
            end
          end

          it_behaves_like "a ListLexer"
        end
      end
    end
  end
end