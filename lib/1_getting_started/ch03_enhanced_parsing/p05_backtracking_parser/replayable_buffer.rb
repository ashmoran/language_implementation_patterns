require 'forwardable'

module GettingStarted
  module EnhancedParsing
    module BacktrackingParser

      class ReplayableBuffer
        extend Forwardable

        def_delegator :@buffer, :[]
        def_delegator :@buffer, :size

        def_delegator :@buffer, :<<
        def_delegator :@buffer, :shift

        class ArrayProxy
          def initialize(buffer = [ ])
            @buffer = buffer
          end

          # Queries

          def [](index)
            @buffer[index]
          end

          def size
            @buffer.size
          end

          # Commands

          def <<(object)
            @buffer << object
          end

          def shift
            @buffer.shift
          end

          # Support

          def dup
            ArrayProxy.new(@buffer.dup)
          end

          def unwrap
            raise RuntimeError.new("No mark has been set")
          end
        end

        class TimeMachine
          def initialize(buffer, snapshot = nil)
            @buffer   = buffer
            @snapshot = snapshot || buffer.dup
          end

          # Queries

          def [](index)
            @snapshot[index]
          end

          def size
            @snapshot.size
          end

          # Commands

          def <<(object)
            @snapshot << object
            @buffer << object
          end

          def shift
            @snapshot.shift
          end

          # Support

          def dup
            TimeMachine.new(self, @snapshot.dup)
          end

          def unwrap
            @buffer
          end
        end

        def initialize
          @buffer = ArrayProxy.new
        end

        def mark
          @buffer = TimeMachine.new(@buffer)
        end

        def release
          @buffer = @buffer.unwrap
        end
      end

    end
  end
end
