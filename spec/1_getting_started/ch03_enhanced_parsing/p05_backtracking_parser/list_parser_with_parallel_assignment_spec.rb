require 'spec_helper'

require '1_getting_started/ch03_enhanced_parsing/p05_backtracking_parser/list_parser_with_parallel_assignment'
require '1_getting_started/ch03_enhanced_parsing/p05_backtracking_parser/lexer_replayable_lookahead'
require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require_relative '../../ch02_basic_parsing/p03_ll1_recursive_descent_parser/list_parser_contract'
require_relative '../../ch02_basic_parsing/p04_llk_recursive_descent_parser/list_parser_assignment_contract'
require_relative 'list_parser_with_parallel_assignment_contract'

module GettingStarted
  module EnhancedParsing
    module BacktrackingParser
      describe "Intergration:", ListParserWithParallelAssignment, "and lexer" do
        let(:input) { "[ a ] = [ b ]" }

        let(:lexer) { BasicParsing::LL1RecursiveDescentLexer::ListLexer.new(input) }
        let(:lookahead) { LexerReplayableLookahead.new(lexer) }
        subject(:parser) { ListParserWithParallelAssignment.new(lookahead) }

        describe "statements" do
          context "a list" do
            let(:input) { "[ a = b, c, d ]" }

            example do
              expect(parser.stat).to be == [ { :a => :b }, :c, :d ]
            end
          end

          context "a parallel assignment" do
            let(:input) { "[ a, b ] = [ c, d ]" }

            example do
              expect(parser.stat).to be == { [ :a, :b ] => [ :c, :d ] }
            end
          end
        end
      end

      describe ListParserWithParallelAssignment do
        let(:tokens) {
          BasicParsing::LL1RecursiveDescentLexer::Token.descriptions_to_tokens(token_descriptions)
        }
        let(:lexer) { tokens.each }
        let(:lookahead) { LexerReplayableLookahead.new(lexer) }
        subject(:parser) { ListParserWithParallelAssignment.new(lookahead) }

        it_behaves_like "a ListParser"
        it_behaves_like "a ListParser with assignment"
        it_behaves_like "a ListParser with parallel assignment"
      end
    end
  end
end