require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p17_nested_scopes/cymbol2'
# require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/symbol_table'
# require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/symbol_table_logger'
# require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/language_symbol'
# require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/variable_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes
      describe Cymbol2, "from the book", pending: true do
        let(:symbol_table) { "not really a symbol table"}

        let(:output_io) { StringIO.new }
        def output
          output_io.rewind
          output_io.read.chomp
        end

        subject(:cymbol) { Cymbol2.new }

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
          cymbol.parse(source).walk

          expect(output.to_s).to be == -%{
            line 2: def method f
            line 2: def x
            line 4: def i
            line 5: def z
            line 5: ref <x:int>
            line 5: ref null
            line 5: ref <z:float>
            line 5: assign to <i:float>
            locals: [z]
            locals: [i]
            args: method<f:float>:[<x:int>]
          }
        }

        specify {
          cymbol.parse(source)

          expect(symbol_table.to_s).to be ==
            "globals: {f=<f:<method:float>>, float=float, int=int, void=void}"
        }
      end
    end
  end
end