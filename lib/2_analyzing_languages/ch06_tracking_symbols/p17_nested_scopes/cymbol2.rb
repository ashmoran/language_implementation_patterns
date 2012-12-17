require_relative 'cymbol2_parser'

module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes

      class Cymbol2
        def initialize
          @parser = CymbolNestedParser.new
        end

        def parse(source)
          @parser.parse(source)
        end
      end

    end
  end
end