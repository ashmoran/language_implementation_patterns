require_relative 'token'

module GettingStarted
  module BasicParsing
    module LL1RecursiveDescentLexer

      # Implements Pattern 2: LL(1) Recursive-Descent Lexer
      #
      # Note that there are two main differences from the example implementation:
      #
      # * I don't use a Token class (which is just a dumb struct in the Java
      #   example), this can be more easily implemented in Ruby with simple hashes.
      #
      # * I set about solving this using standard Ruby iterators with blocks,
      #   which makes some bits more idiomatic and some bits more complex. The
      #   Java example looks ahead to the next character, whereas with blocks
      #   we have to `redo` if we detect we've entered a different token type.
      #   Because of this, the code has ended up with a State implementation,
      #   albeit a slightly wacky one.
      #
      # * There's the minor difference that I forgot to allow parsing capital
      #   letters in names. Oops.
      #
      # ERRATA: I just realised that the whole point of LL(1) is to *look ahead*
      # and therefore this implementation using blocks misses the point. Sight.
      # Oh well, from the outside, it's behaviourally equivalent, ie passes all
      # the same tests it would do if we weren't `redo`ing enumerator blocks.
      # I'm not going to refactor it unless I have to.
      class ListLexer
        def initialize(input)
          @input = input

          # Hack to work around the fact I didn't implement this as a pull system
          @tokens = tokenize_all.each
        end

        def peek
          @tokens.peek
        end

        def next
          @tokens.next
        end

        private

        def tokenize_all
          [ ].tap do |tokens|
            tokenize do |token|
              tokens << token
            end
          end
        end

        def tokenize(&block)
          switch_to_mode(:normal)

          @input.chars.each do |char|
            match_result =
              catch :state_changed do
                match(char, &block)
              end

            redo if match_result == :state_changed
          end

          finish(&block)
        end

        def match_normal(char, &block)
          case char
          when " ", "\t", "\n"
          when "["
            yield(Token.new(lbrack: char))
          when ","
            yield(Token.new(comma: char))
          when "="
            yield(Token.new(equals: char))
          when "]"
            yield(Token.new(rbrack: char))
          when "a".."z"
            switch_to_mode(:name)
            throw(:state_changed, :state_changed)
          else
            raise ArgumentError.new("Invalid character: #{char}")
          end
        end

        def match_name(char, &block)
          case char
          when "a".."z"
            @name << char
          else
            yield(Token.new(name: @name))
            switch_to_mode(:normal)
            throw(:state_changed, :state_changed)
          end
        end

        def finish_normal(&block)
          yield(Token.new(eof: nil))
        end

        def finish_name(&block)
          yield(Token.new(name: @name))
          yield(Token.new(eof: nil))
        end

        # This is an insane way to implement the State pattern, but I've left it in purely
        # because it's so ridiculous, and this is only the first pattern in the book
        def switch_to_mode(mode)
          @name = ""

          singleton_class.send(:alias_method, :match, :"match_#{mode}")
          singleton_class.send(:alias_method, :finish, :"finish_#{mode}")
        end
      end

    end
  end
end