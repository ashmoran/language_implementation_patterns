require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p17_nested_scopes/cymbol2_parser'

RSpec::Matchers.define :parse do
  match do |source|
    parser.parse(source)
  end
end

module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes

      describe CymbolNestedParser do
        subject(:parser) { CymbolNestedParser.new }

        let(:tree) { parser.parse(source) }

        describe "empty program" do
          example do
            expect("").to parse
          end
          example do
            expect("  ").to parse
          end
          example do
            expect(" \n").to parse
          end
          example do
            expect("\t\t\t").to parse
          end
          example do
            expect("\n\n\n").to parse
          end
          example do
            expect("\n \n\t\n").to parse
          end
        end

        describe "comments" do
          example do
            expect("// this is a comment\n").to parse
          end
          example do
            expect("// this is a comment").to parse
          end
          example do
            expect(" // this is a comment").to parse
          end
        end
      end

    end
  end
end