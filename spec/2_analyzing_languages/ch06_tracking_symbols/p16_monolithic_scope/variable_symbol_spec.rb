require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/variable_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      describe VariableSymbol do
        let(:type) { LanguageSymbol.new(:type) }
        subject(:symbol) { VariableSymbol.new(:name, type) }

        its(:to_s) { should be == "<name:type>" }

        describe "#==" do
          example do
            expect(symbol).to be == VariableSymbol.new(:name, type)
          end

          example do
            expect(symbol).to be == VariableSymbol.new("name", type)
          end

          example do
            expect(symbol).to_not be == VariableSymbol.new(:bar, type)
          end

          example do
            expect(symbol).to_not be == VariableSymbol.new(:name, LanguageSymbol.new(:wrong_type))
          end

          example do
            expect(symbol).to_not be == :name
          end
        end

        describe "#name" do
          its(:name) { should be == :name }

          it "is always a symbol" do
            expect(VariableSymbol.new("name", :ununused_type).name).to be == :name
          end
        end
      end
    end
  end
end