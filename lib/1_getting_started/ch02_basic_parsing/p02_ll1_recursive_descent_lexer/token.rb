module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer
      class Token
        attr_reader :type, :value

        class << self
          def descriptions_to_tokens(descriptions)
            descriptions.map { |description| Token.new(description) }
          end
        end

        def initialize(description)
          @type   = description.keys.first
          @value  = description.values.first
        end

        def to_hash
          { @type => @value }
        end

        def inspect
          @type.inspect
        end

        def ==(other)
          @type == other.type && @value == other.value
        end
      end
    end
  end
end