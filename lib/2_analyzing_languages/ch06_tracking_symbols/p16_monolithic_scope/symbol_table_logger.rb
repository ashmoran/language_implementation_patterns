module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      # A Decorator for SymbolTable
      #
      # Note this makes the questionable decision of only logging if location
      # metadata is available. Arguable we should have distinct #resolve_at_location
      # and #define_at_location methods to be used by clients (I haven't thought
      # this through though).
      class SymbolTableLogger
        def initialize(symbol_table, output_io)
          @symbol_table = symbol_table
          @output_io    = output_io
        end

        def resolve(symbol_name, metadata = { })
          @symbol_table.resolve(symbol_name).tap do |symbol|
            log("ref", symbol, metadata)
          end
        end

        def define(symbol, metadata = { })
          log("def", symbol, metadata)
          @symbol_table.define(symbol)
        end

        private

        def log(event, item, metadata)
          @output_io.puts("#{metadata[:location]}: #{event} #{item}")
        end
      end
    end
  end
end