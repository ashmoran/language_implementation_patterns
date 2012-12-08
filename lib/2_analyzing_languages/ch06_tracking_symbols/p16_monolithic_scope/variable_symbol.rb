module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      class VariableSymbol
        attr_reader :name, :type

        def initialize(name, type)
          @name = name.to_sym
          @type = type
        end

        def ==(other)
          other.is_a?(VariableSymbol) &&
            @name == other.name &&
            @type == other.type
        end

        def to_s
          "<#{@name}:#{@type}>"
        end
      end
    end
  end
end