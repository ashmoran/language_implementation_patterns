require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/symbol_table'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/language_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      describe SymbolTable do
        subject(:symbol_table) { SymbolTable.new }

        describe "#define" do
          it "ignores metadata" do
            expect {
              symbol_table.define(LanguageSymbol.new(:foo), unused: "stuff")
            }.to_not raise_error(ArgumentError)
          end
        end

        describe "#resolve" do
          context "undefined symbol" do
            specify {
              expect {
                symbol_table.resolve("foo")
              }.to raise_error(RuntimeError, "Unknown symbol: foo")
            }

            it "ignores metadata" do
              expect {
                symbol_table.resolve("foo", unused: "stuff")
              }.to_not raise_error(ArgumentError)
            end
          end

          context "defined symbol" do
            let(:symbol) { LanguageSymbol.new(:foo) }

            before(:each) do
              symbol_table.define(symbol)
            end

            specify {
              expect(symbol_table.resolve("foo")).to equal(symbol)
            }

            specify {
              expect(symbol_table.resolve(:foo)).to equal(symbol)
            }
          end
        end

        describe "#to_s" do
          before(:each) do
            symbol_table.define(LanguageSymbol.new(:foo))
            symbol_table.define(LanguageSymbol.new(:bar))
            symbol_table.define(LanguageSymbol.new(:baz))
          end

          it "outputs in alphabetic order" do
            expect(symbol_table.to_s).to be ==
              "globals: {bar=bar, baz=baz, foo=foo}"
          end
        end
      end
    end
  end
end