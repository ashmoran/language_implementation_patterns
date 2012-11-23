require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      describe ListLexer do
        subject(:lexer) { ListLexer.new(input) }

        let(:output) { [ ] }

        def tokenize_all_input
          lexer.each do |token|
            output << token
          end
        end

        describe "#each" do
          let(:input) { "[a]" }

          it "lets you enumerate manually so we can use this like the book example expects" do
            tokens = lexer.each
            loop do
              begin
                output << tokens.next
              rescue StopIteration
                break
              end
            end

            expect(output).to be == [
              { lbrack: "[" }, { name: "a" }, { rbrack: "]" }, { eof: nil }
            ]
          end
        end

        context "valid input" do
          before(:each) do
            tokenize_all_input
          end

          context "empty string" do
            let(:input) { "" }

            specify {
              expect(output).to be == [ { eof: nil } ]
            }
          end

          context "blank string" do
            context "spaces, tabs, newlines" do
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
            let(:input) { " [ \t, \n, ] \n" }

            specify {
              expect(output).to be == [
                { lbrack: "[" }, { comma: "," }, { comma: "," }, { rbrack: "]" }, { eof: nil }
              ]
            }
          end
        end

        context "invalid input" do
          context "invalid characters" do
            context "in normal context" do
              let(:input) { "@" }

              specify {
                expect { tokenize_all_input }.to raise_error(ArgumentError, "Invalid character: @")
              }
            end

            context "in a name" do
              let(:input) { "a$"}

              specify {
                expect { tokenize_all_input }.to raise_error(ArgumentError, "Invalid character: $")
              }
            end
          end
        end
      end
    end
  end
end