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
        rescue RuntimeError => e # Eek! Seems we were using too geneneral an error class...
          log("ref [failed]", symbol_name, metadata)
        end

        def define(symbol, metadata = { })
          log("def", symbol, metadata)
          @symbol_table.define(symbol)
        end

        # Hacked in as part of the NestedScopes code...
        # I'm not taking too much care to refactor now
        def define_as_scope(symbol, metadata = { })
          log("defscope", symbol, metadata)
          @symbol_table.define_as_scope(symbol)
        end

        # Also hacked in
        def push_scope
          @symbol_table.push_scope
        end

        # And this
        def pop_scope
          @symbol_table.pop_scope
        end

        private

        def log(event, item, metadata)
          @output_io.puts("#{metadata[:location]}: #{event} #{item}")
        end
      end
    end
  end
end