require 'spec_helper'

require '1_getting_started/ch02_basic_parsing/p02_ll1_recursive_descent_lexer/token'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      describe Token do
        subject(:token) { Token.new(token_type: "token_value") }

        its(:type)    { should be == :token_type }
        its(:value)   { should be == "token_value" }
        its(:to_hash) { should be == { token_type: "token_value" } }

        describe "==" do
          it "knows equality" do
            expect(token).to be == Token.new(token_type: "token_value")
          end

          it "compares type" do
            expect(token).to_not be == Token.new(wrong_token_type: "token_value")
          end

          it "compares value" do
            expect(token).to_not be == Token.new(token_type: "wrong_token_value")
          end
        end

        describe ".descriptions_to_tokens" do
          example do
            expect(
              Token.descriptions_to_tokens([{ a: "one" }, { b: "two" }])
            ).to be == [
              Token.new(a: "one"), Token.new(b: "two")
            ]
          end
        end
      end
    end
  end
end