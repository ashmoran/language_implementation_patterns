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
            expect { parser.list }.to raise_error(ArgumentError, "Expected :lbrack, found :eof")
          }
        end

        # The example in the book (deliberately?) avoids this case, but it's an obvious
        # TDD bootstrapping case, and turned out to be not too difficult to implement
        # compared to the Java example
        context "empty list" do
          let(:tokens) {
            [
              { lbrack: "[" },
              { rbrack: "]" },
              { eof:    nil }
            ]
          }

          specify {
            expect(parser.list).to be == [ ]
          }
        end

        context "list with a name" do
          let(:tokens) {
            [
              { lbrack: "[" },
              { name:   "a" },
              { rbrack: "]" },
              { eof:    nil }
            ]
          }

          specify {
            expect(parser.list).to be == [ :a ]
          }
        end

        context "list with a multiple names" do
          let(:tokens) {
            [
              { lbrack: "[" },
              { name:   "a" },
              { comma:  "," },
              { name:   "b" },
              { comma:  "," },
              { name:   "c" },
              { rbrack: "]" },
              { eof:    nil }
            ]
          }

          specify {
            expect(parser.list).to be == [ :a, :b, :c ]
          }
        end

        context "list of lists" do
          let(:tokens) {
            [
              { lbrack: "[" },
                { name:   "a" },
                { comma:  "," },
                  { lbrack: "[" },
                    { name:   "x" },
                    { comma:  "," },
                    { name:   "y" },
                  { rbrack: "]" },
                { comma:  "," },
                { name:   "b" },
              { rbrack: "]" },
              { eof:    nil }
            ]
          }

          specify {
            expect(parser.list).to be == [ :a, [ :x, :y ], :b ]
          }
        end
      end
    end
  end
end