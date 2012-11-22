require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      describe ListLexer do
        subject(:lexer) { ListLexer.new(input) }

        let(:output) { [ ] }

        before(:each) do
          lexer.each do |token|
            output << token
          end
        end

        context "empty string" do
          let(:input) { "" }

          specify {
            expect(output).to be == [ { eof: nil } ]
          }
        end

        context "blank string" do
          context "spaces" do
            let(:input) { "   " }

            specify {
              expect(output).to be == [ { eof: nil } ]
            }
          end
        end

        context "lbrack" do
          let(:input) { "[" }

          specify {
            expect(output).to be == [ { lbrack: "[" }, { eof: nil } ]
          }
        end

        context "comma" do
          let(:input) { "," }

          specify {
            expect(output).to be == [ { comma: "," }, { eof: nil } ]
          }
        end

        context "rbrack" do
          let(:input) { "]" }

          specify {
            expect(output).to be == [ { rbrack: "]" }, { eof: nil } ]
          }
        end

        context "names" do
          context "single letter" do
            let(:input) { "a" }

            specify {
              expect(output).to be == [ { name: "a" }, { eof: nil } ]
            }
          end

          context "multi-letter" do
            let(:input) { "abcdefghijklmnopqrstuvwxyz" }

            specify {
              expect(output).to be == [ { name: "abcdefghijklmnopqrstuvwxyz" }, { eof: nil } ]
            }
          end

          context "in a list" do
            let(:input) { "[ a, xyz, bc ]" }

            specify {
              expect(output).to be == [
                { lbrack: "[" },
                { name:   "a" },
                { comma:  "," },
                { name:   "xyz" },
                { comma:  "," },
                { name:   "bc" },
                { rbrack: "]" },
                { eof:    nil }
              ]
            }
          end
        end

        context "delimiters, separators, and spaces" do
          let(:input) { " [ , , ] " }

          specify {
            expect(output).to be == [
              { lbrack: "[" }, { comma: "," }, { comma: "," }, { rbrack: "]" }, { eof: nil }
            ]
          }
        end
      end
    end
  end
end