require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer'
require '1_getting_started/ch03_enhanced_parsing/p05_backtracking_parser/lexer_replayable_lookahead'
require_relative '../../ch02_basic_parsing/p02_ll1_recursive_descent_lexer/list_lexer_contract'

module GettingStarted
  module EnhancedParsing
    module BacktrackingParser
      shared_examples_for "LexerReplayableLookahead#peek" do
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

      shared_examples_for "LexerReplayableLookahead#speculate" do
        specify {
          lexer.speculate do
            expect(lexer.peek.value).to be == "["
            expect(lexer.next.value).to be == "["
            expect(lexer.next.value).to be == "a"
          end
        }

        specify {
          lexer.next
          expect {
            lexer.speculate do
              lexer.next
            end
          }.to_not change { lexer.peek.value }
        }

        specify {
          expect(lexer.peek.value).to be == "["
          lexer.speculate do
            lexer.next
            expect(lexer.peek.value).to be == "a"
            lexer.speculate do
              lexer.next
              expect(lexer.peek.value).to be == "="
            end
            expect(lexer.peek.value).to be == "a"
          end
          expect(lexer.peek.value).to be == "["
        }

        describe "#if_speculating" do
          specify {
            should_not_receive(:was_speculating)
            lexer.if_speculating do
              was_speculating
            end
          }

          specify {
            should_receive(:was_speculating)
            lexer.speculate do
              lexer.if_speculating do
                was_speculating
              end
            end
          }

          specify {
            should_receive(:was_speculating)
            lexer.speculate do
              lexer.speculate do
                # nothing here
              end
              lexer.if_speculating do
                was_speculating
              end
            end
          }
        end

        describe "error handling" do
          it "(re-)raises errors" do
            expect {
              lexer.speculate do
                raise "re-raised error"
              end
            }.to raise_error(RuntimeError, "re-raised error")
          end

          it "is not disturbed by errors" do
            lexer.speculate do
              lexer.next
              lexer.next
              raise "ignored error"
            end rescue nil

            expect(lexer.next.value).to be == "["
            expect(lexer.next.value).to be == "a"
          end
        end
      end

      describe LexerReplayableLookahead do
        describe "lookahead" do
          let(:tokens) {
            BasicParsing::LL1RecursiveDescentLexer::Token.descriptions_to_tokens(
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

          subject(:lexer) { LexerReplayableLookahead.new(underlying_lexer) }

          describe "#peek" do
            it_behaves_like "LexerReplayableLookahead#peek"
          end

          describe "#speculate" do
            it_behaves_like "LexerReplayableLookahead#speculate"
          end
        end

        context "wrapping a ListLexer" do
          let(:input) { "[ a = b ]" }
          let(:underlying_lexer) { BasicParsing::LL1RecursiveDescentLexer::ListLexer.new(input) }
          subject(:lexer) { LexerReplayableLookahead.new(underlying_lexer) }

          let(:collected_output) { [ ] }
          let(:output) {
            collected_output.map { |token| token.to_hash }
          }

          it_behaves_like "a ListLexer"

          describe "#peek" do
            it_behaves_like "LexerReplayableLookahead#peek"
          end

          describe "#speculate" do
            it_behaves_like "LexerReplayableLookahead#speculate"
          end
        end
      end
    end
  end
end