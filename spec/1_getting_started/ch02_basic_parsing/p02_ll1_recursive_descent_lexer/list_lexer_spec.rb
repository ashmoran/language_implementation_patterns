require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require_relative 'list_lexer_contract'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      describe ListLexer do
        subject(:lexer) { ListLexer.new(input) }

        let(:collected_output) { [ ] }
        let(:output) {
          collected_output.map { |token| token.to_hash }
        }

        it_behaves_like "a ListLexer"
      end
    end
  end
end