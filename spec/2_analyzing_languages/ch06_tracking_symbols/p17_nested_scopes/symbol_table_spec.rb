require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p17_nested_scopes/symbol_table'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/language_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes
      # Easy access to the existing LanguageSymbol
      include MonolithicScope

      describe SymbolTable do
        subject(:symbol_table) { SymbolTable.new }

        context "single scope" do
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
                "symbols: {bar=bar, baz=baz, foo=foo}"
            end
          end
        end

        describe "nested scopes" do
          let(:symbol) { LanguageSymbol.new(:foo) }

          before(:each) do
            symbol_table.define(symbol)
            symbol_table.push_scope
          end

          it "gives access to the higher scope" do
            expect(symbol_table.resolve(:foo)).to equal(symbol)
          end

          describe "overriding" do
            let(:new_foo) { LanguageSymbol.new(:foo) }

            before(:each) do
              symbol_table.define(new_foo)
            end

            it "lets you override a symbol" do
              expect(symbol_table.resolve(:foo)).to equal(new_foo)
            end

            it "lets you pop the scope tree to get the old symbol back" do
              symbol_table.pop_scope
              expect(symbol_table.resolve(:foo)).to equal(symbol)
            end

            it "updates #to_s" do
              pending
            end
          end
        end

        describe "scope symbols" do
          # Using a mock here bleeds some implementation details of the aggregate,
          # we should probably remove this if we get a suitable integration test
          let(:scope_symbol) {
            mock("ScopeSymbol", name: :bar, wrap: nil, resolve: :trust_passed_through)
          }

          it "defines the symbol" do
            symbol_table.define_as_scope(scope_symbol)
            expect(symbol_table.resolve(:bar)).to equal(:trust_passed_through)
          end

          it "ignores metadata" do
            expect {
              symbol_table.define_as_scope(scope_symbol, unused: "stuff")
            }.to_not raise_error(ArgumentError)
          end

          it "pushes the symbol as a scope" do
            symbol_table.define(LanguageSymbol.new(:moo))

            scope_symbol.should_receive(:wrap) do |parent_scope|
              expect(parent_scope.resolve(:moo))
            end

            symbol_table.define_as_scope(scope_symbol)
          end

          it "uses the pushed scope" do
            symbol_table.define_as_scope(scope_symbol)
            scope_symbol.should_receive(:resolve).with(:baz)
            symbol_table.resolve(:baz)
          end
        end
      end
    end
  end
end