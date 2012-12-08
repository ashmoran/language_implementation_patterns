module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      class SymbolTable
        def initialize
          @symbols = { }
        end

        def define(symbol, metadata = { })
          @symbols[symbol.name] = symbol
        end

        def resolve(name, metadata = { })
          @symbols.fetch(name.to_sym) {
            raise "Unknown symbol: #{name}"
          }
        end

        def to_s
          "globals: {#{key_value_pairs.join(", ")}}"
        end

        private

        def key_value_pairs
          @symbols.keys.sort.map { |key| "#{key}=#{@symbols[key]}" }
        end
      end
    end
  end
end