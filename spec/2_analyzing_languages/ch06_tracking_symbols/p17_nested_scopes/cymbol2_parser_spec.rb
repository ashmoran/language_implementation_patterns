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

        # If something goes wrong in here, we're missing a focused example!
        describe "a complex program" do
          example do
            expect(<<-C).to parse
              // intro comment
              int i = 9;
              float j;
              int k = i+2;

              float f(int x, float y)
              {
                float i;
                { float z = x+y; i = z; }
                return i;
              }

              void g()
              {
                f(i, 2);
              }
            C
          end
        end

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

        describe "variable declaration" do
          context "without initialization" do
            example do
              expect("int foo;").to parse
            end
            example do
              expect("int foo ;").to parse
            end
            example do
              expect("float foo;").to parse
            end
          end

          context "with initialization" do
            context "to a literal" do
              example do
                expect("int foo=99;").to parse
              end
              example do
                expect("int foo = 99 ;").to parse
              end
            end

            context "to a variable" do
              example do
                expect("int foo = x;").to parse
              end
            end

            context "to an arbitrary expression" do
              example do
                expect("int foo = x + 1;").to parse
              end
              example do
                expect("int foo = x+1;").to parse
              end
            end
          end
        end

        describe "assignment" do
          example do
            expect("foo=bar;").to parse
          end
          example do
            expect("foo = bar;").to parse
          end
          example do
            expect("foo = 1;").to parse
          end
        end

        describe "blocks" do
          example do
            expect("{}").to parse
          end
          example do
            expect("{ }").to parse
          end
          example do
            expect("{ int i; }").to parse
          end
          example do
            expect("{ int i; x = y; }").to parse
          end
          example do
            expect("{
              int i;
              x = y;
            }").to parse
          end
          example do
            expect("{ x = a + b; }").to parse
          end

          describe "nested" do
            example do
              expect("{{}}").to parse
            end
            example do
              expect("{ { } }").to parse
            end
            example do
              expect("{
                int i;
                {
                  float k;
                }
              }").to parse
            end
          end
        end

        describe "methods" do
          describe "definitions" do
            example do
              expect("int foo(){}").to parse
            end
            example do
              expect("int foo() { }").to parse
            end
            example do
              expect("int foo()\n{ }").to parse
            end
            example do
              expect("int foo(int x) { }").to parse
            end
            example do
              expect("int foo(int x, float y) { }").to parse
            end
            example do
              expect("int foo( int x ,float y ) { }").to parse
            end
            example do
              expect("float f() { int i; }").to parse
            end
            example do
              expect("float f() { return a + b; }").to parse
            end
          end
          describe "calls" do
            example do
              expect("foo();").to parse
            end
            example do
              expect("foo( ) ;").to parse
            end
            example do
              expect("f(a);").to parse
            end
            example do
              expect("f(a, b);").to parse
            end
            example do
              expect("f(a, b + 1);").to parse
            end
          end
        end
      end

    end
  end
end