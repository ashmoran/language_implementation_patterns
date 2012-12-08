require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/cymbol'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/symbol_table'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/symbol_table_logger'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/language_symbol'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/variable_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      describe Cymbol do
        let(:symbol_table) { mock(SymbolTable, resolve: nil, define: nil) }

        let(:cymbol) { Cymbol.new(symbol_table) }

        context "an uninitialised variable" do
          let(:source) { "float j;" }

          specify {
            symbol_table.should_receive(:resolve).with("float", hash_including(location: "line 1"))
            cymbol.parse(source)
          }
        end

        context "an initialized variable" do
          let(:source) { "int i = 9;" }

          let(:int) { LanguageSymbol.new(:int) }

          before(:each) do
            symbol_table.stub(resolve: int)
          end

          specify {
            symbol_table.should_receive(:resolve).with(
              "int", hash_including(location: "line 1")
            ).ordered
            symbol_table.should_receive(:define).with(
              VariableSymbol.new(:i, LanguageSymbol.new(:int)),
              hash_including(location: "line 1")
            ).ordered

            cymbol.parse(source)
          }
        end

        context "a variable initialized with an expression" do
          let(:source) { "int k = i + 2;" }

          let(:float) { LanguageSymbol.new(:float) }

          before(:each) do
            symbol_table.stub(resolve: float)
          end

          specify {
            symbol_table.should_receive(:resolve).with(
              "int", hash_including(location: "line 1")
            ).ordered
            symbol_table.should_receive(:resolve).with(
              "i", hash_including(location: "line 1")
            ).ordered
            symbol_table.should_receive(:define).with(
              VariableSymbol.new(:k, float), hash_including(location: "line 1")
            ).ordered

            cymbol.parse(source)
          }
        end
      end

      describe Cymbol, "from the book" do
        let(:symbol_table) { SymbolTable.new }
        subject(:cymbol) { Cymbol.new(symbol_table_for_parser) }

        let(:source) {
          -%{
            int i = 9;
            float j;
            int k = i+2;
          }
        }

        before(:each) do
          # Bypass any logging
          symbol_table.define(LanguageSymbol.new(:int))
          symbol_table.define(LanguageSymbol.new(:float))
        end

        context "but with no logging" do
          let(:symbol_table_for_parser) { symbol_table }

          specify {
            expect { cymbol.parse(source) }.to_not raise_error
          }
        end

        context "with logging as described" do
          let(:output_io) { StringIO.new }
          def output
            output_io.rewind
            output_io.read.chomp
          end

          let(:symbol_table_for_parser) { SymbolTableLogger.new(symbol_table, output_io) }

          # Changed slightly because to produce the same output as the book
          # requires an inordinate increase in complexity in the code
          #
          # Test output from the book:
          #   line 1: ref int
          #   line 1: def i
          #   line 2: ref float
          #   line 2: def j
          #   line 3: ref int
          #   line 3: ref to <i:int>
          #   line 3: def k
          specify {
            cymbol.parse(source)

            expect(output.to_s).to be == -%{
              line 1: ref int
              line 1: def <i:int>
              line 2: ref float
              line 2: def <j:float>
              line 3: ref int
              line 3: ref <i:int>
              line 3: def <k:int>
            }
          }

          # We don't write this to the output just to avoid having to pass an IO in to Cymbol
          specify {
            cymbol.parse(source)

            expect(symbol_table.to_s).to be ==
              "globals: {float=float, i=<i:int>, int=int, j=<j:float>, k=<k:int>}"
          }
        end
      end
    end
  end
end