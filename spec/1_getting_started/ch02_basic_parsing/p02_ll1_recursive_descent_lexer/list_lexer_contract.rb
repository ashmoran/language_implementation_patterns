require_relative 'enumerator_contract'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      shared_examples_for "a ListLexer" do
        def tokenize_all_input
          begin
            loop do
              collected_output << lexer.next
            end
          rescue StopIteration => e

          end
        end

        describe "#peek" do
          let(:input) { "[a]" }

          it "lets you see the next character" do
            expect {
              lexer.next
            }.to change {
              lexer.peek
            }.from(Token.new(lbrack: "[")).to(Token.new(name: "a"))
          end
        end

        describe "Enumerator-like properties" do
          let(:input) { "" }

          def advance_to_end
            lexer.next
          end

          it_behaves_like "an Enumerator"
        end

        context "valid input" do
          before(:each) do
            tokenize_all_input
          end

          context "empty string" do
            let(:input) { "" }

            it "marks the end of the tokens explicitly" do
              expect(output).to be == [ { eof: nil } ]
            end
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

          context "equals" do
            let(:input) { "=" }

            specify {
              expect(output).to be == [ { equals: "=" }, { eof: nil } ]
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