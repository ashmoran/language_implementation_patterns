require 'spec_helper'

require '1_getting_started/ch03_enhanced_parsing/p06_memoizing_parser/memoizing_list_parser'
require '1_getting_started/ch03_enhanced_parsing/p05_backtracking_parser/lexer_replayable_lookahead'
require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require_relative '../../ch02_basic_parsing/p03_ll1_recursive_descent_parser/list_parser_contract'
require_relative '../../ch02_basic_parsing/p04_llk_recursive_descent_parser/list_parser_assignment_contract'
require_relative '../p05_backtracking_parser/list_parser_with_parallel_assignment_contract'

module GettingStarted
  module EnhancedParsing
    module MemoizingParser

      # The spec for this is identical to the backtracking parser, only the
      # implementation differs. I've decided not to write any specs to prove
      # eg performance or memory usage, as for my purposes I only want to
      # understand what is going on, not be able to implement these efficiently
      # myself.
      describe MemoizingListParser do
        let(:tokens) {
          BasicParsing::LL1RecursiveDescentLexer::Token.descriptions_to_tokens(token_descriptions)
        }
        let(:lexer) { tokens.each }
        let(:lookahead) { BacktrackingParser::LexerReplayableLookahead.new(lexer) }
        subject(:parser) { MemoizingListParser.new(lookahead) }

        it_behaves_like "a ListParser"
        it_behaves_like "a ListParser with assignment"
        it_behaves_like "a ListParser with parallel assignment"
      end

    end
  end
end
