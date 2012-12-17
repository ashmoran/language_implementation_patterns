require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p17_nested_scopes/cymbol2'
require '2_analyzing_languages/ch06_tracking_symbols/p17_nested_scopes/symbol_table'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/symbol_table_logger'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/language_symbol'
# require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/variable_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes
      include MonolithicScope

      describe Cymbol2, "from the book" do
        let(:symbol_table) { SymbolTable.new }
        let(:symbol_table_logger) { SymbolTableLogger.new(symbol_table, output_io) }

        let(:output_io) { StringIO.new }
        def output
          output_io.rewind
          output_io.read.chomp
        end

        subject(:cymbol) { Cymbol2.new }

        before(:each) do
          # Bypass any logging
          symbol_table.define(LanguageSymbol.new(:int))
          symbol_table.define(LanguageSymbol.new(:float))
        end

        let(:source) {
          -%{
            // global scope
            float f(int x)
            {
              float i;
              { float z = x+y; i = z; }
            }
          }
        }

        specify {
          cymbol.parse(source).walk(symbol_table_logger)

          # Changed a bit: I made it as close as I felt was worth it,
          # but some stuff is quite hard (eg assignment, unless we start)
          # extending the symbol table for this
          expect(output.to_s).to be == -%{
            line 2: ref float
            line 2: defscope method<f:float>
            line 2: ref int
            line 2: def <x:int>
            line 4: ref float
            line 4: def <i:float>
            line 5: ref float
            line 5: ref <x:int>
            line 5: ref [failed] y
            line 5: def <z:float>
            line 5: ref <i:float>
            line 5: ref <z:float>
          }
        }
      end
    end
  end
end