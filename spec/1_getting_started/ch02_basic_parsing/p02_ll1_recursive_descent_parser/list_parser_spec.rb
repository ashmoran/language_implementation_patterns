require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_parser/list_parser'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'

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
        let(:lexer) { mock(LL1RecursiveDescentLexer::ListLexer, each: tokens.each) }

        subject(:parser) { ListParser.new(lexer) }

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

        context "list of list of lists to prove to Bobby my code really works" do
          let(:tokens) {
            [
              { lbrack: "[" },
                { name:   "a" },
                { comma:  "," },
                  { lbrack: "[" },
                    { name:   "x" },
                    { comma:  "," },
                      { lbrack: "[" },
                        { name:   "i" },
                        { comma:  "," },
                        { name:   "j" },
                      { rbrack: "]" },
                  { rbrack: "]" },
                { comma:  "," },
                { name:   "b" },
              { rbrack: "]" },
              { eof:    nil }
            ]
          }

          specify {
            expect(parser.list).to be == [ :a, [ :x, [ :i, :j ] ], :b ]
          }
        end

        context "invalid input" do
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

          context "unclosed list" do
            let(:tokens) {
              [
                { lbrack: "[" },
                { eof:    nil }
              ]
            }

            specify {
              expect { parser.list }.to raise_error(
                ArgumentError, "Expected :lbrack, :name or :rbrack, found :eof"
              )
            }
          end

          context "missing name before a comma" do
            let(:tokens) {
              [
                { lbrack: "[" },
                { comma:  "," },
                { rbrack: "]" },
                { eof:    nil }
              ]
            }

            specify {
              expect { parser.list }.to raise_error(
                ArgumentError, "Expected :lbrack, :name or :rbrack, found :comma"
              )
            }
          end

          context "missing name after a comma" do
            let(:tokens) {
              [
                { lbrack: "[" },
                { name:   "a" },
                { comma:  "," },
                { rbrack: "]" },
                { eof:    nil }
              ]
            }

            specify {
              expect { parser.list }.to raise_error(
                ArgumentError, "Expected :name or :lbrack, found :rbrack"
              )
            }
          end
        end
      end
    end
  end
end