require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/symbol_table'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/symbol_table_logger'

module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      describe SymbolTableLogger do
        let(:symbol_table) { mock(SymbolTable, define: nil, resolve: :resolved_symbol) }

        let(:output_io) { StringIO.new }
        def output
          output_io.rewind
          output_io.read.chomp
        end

        subject(:logger) { SymbolTableLogger.new(symbol_table, output_io) }

        describe "#resolve" do
          specify {
            symbol_table.should_receive(:resolve).with(:symbol_name)
            logger.resolve(:symbol_name).should be == :resolved_symbol
          }

          specify {
            logger.resolve(:symbol_name, location: "line 1")
            expect(output).to be == "line 1: ref resolved_symbol"
          }
        end

        describe "#define" do
          specify {
            logger.define(:symbol, location: "line 1")
            expect(output).to be == "line 1: def symbol"
          }

          specify {
            symbol_table.should_receive(:define).with(:symbol)
            logger.define(:symbol)
          }
        end
      end
    end
  end
end