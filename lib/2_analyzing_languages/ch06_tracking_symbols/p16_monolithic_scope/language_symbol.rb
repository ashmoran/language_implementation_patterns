module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      class LanguageSymbol
        attr_reader :name

        def initialize(name)
          @name = name.to_sym
        end

        def ==(other)
          other.is_a?(LanguageSymbol) && @name == other.name
        end

        def to_s
          @name.to_s
        end
      end
    end
  end
end