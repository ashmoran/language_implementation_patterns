require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/language_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      describe LanguageSymbol do
        subject(:symbol) { LanguageSymbol.new(:foo) }

        its(:to_s) { should be == "foo" }

        describe "#==" do
          example do
            expect(symbol).to be == LanguageSymbol.new(:foo)
          end

          example do
            expect(symbol).to be == LanguageSymbol.new("foo")
          end

          example do
            expect(symbol).to_not be == LanguageSymbol.new(:bar)
          end

          example do
            expect(symbol).to_not be == :foo
          end
        end

        describe "#name" do
          its(:name) { should be == :foo }

          it "is always a symbol" do
            expect(LanguageSymbol.new("foo").name).to be == :foo
          end
        end
      end
    end
  end
end