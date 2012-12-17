require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p17_nested_scopes/method_symbol'
require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/language_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes
      describe MethodSymbol do
        let(:type) { LanguageSymbol.new(:type) }
        subject(:symbol) { MethodSymbol.new(:name, type) }

        its(:to_s) { should be == "method<name:type>" }

        describe "#==" do
          example do
            expect(symbol).to be == MethodSymbol.new(:name, type)
          end

          example do
            expect(symbol).to be == MethodSymbol.new("name", type)
          end

          example do
            expect(symbol).to_not be == MethodSymbol.new(:bar, type)
          end

          example do
            expect(symbol).to_not be == MethodSymbol.new(:name, LanguageSymbol.new(:wrong_type))
          end

          example do
            expect(symbol).to_not be == :name
          end
        end

        describe "#name" do
          its(:name) { should be == :name }

          it "is always a symbol" do
            expect(MethodSymbol.new("name", :ununused_type).name).to be == :name
          end
        end
      end
    end
  end
end