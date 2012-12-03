require 'spec_helper'

require '1_getting_started/ch03_enhanced_parsing/p05_backtracking_parser/replayable_buffer'

module GettingStarted
  module EnhancedParsing
    module BacktrackingParser

      describe ReplayableBuffer do
        subject(:buffer) { ReplayableBuffer.new }

        context "used without marking" do
          describe "#[]" do
            example do
              expect(buffer[0]).to be_nil
              expect(buffer[1]).to be_nil
              expect(buffer[2]).to be_nil
              expect(buffer[-1]).to be_nil
            end

            example do
              buffer << :a
              buffer << :b

              expect(buffer[0]).to be == :a
              expect(buffer[1]).to be == :b
              expect(buffer[2]).to be_nil
              expect(buffer[-1]).to be == :b
            end
          end

          describe "#shift" do
            example do
              expect(buffer.shift).to be_nil
            end

            example do
              buffer << :a
              buffer << :b

              expect(buffer.shift).to be == :a
              expect(buffer.shift).to be == :b
              expect(buffer.shift).to be_nil
            end
          end

          describe "#size" do
            example do
              expect {
                buffer << :a
                buffer << :b
              }.to change { buffer.size }.from(0).to(2)
            end

            example do
              buffer << :a
              buffer << :b
              expect { buffer.shift }.to change { buffer.size }.from(2).to(1)
              expect { buffer.shift }.to change { buffer.size }.from(1).to(0)
            end
          end

          describe "#release" do
            it "raises an error" do
              expect {
                buffer.release
              }.to raise_error(RuntimeError, "No mark has been set")
            end
          end
        end

        context "with a mark" do
          before(:each) do
            buffer << :premark_a
            buffer << :premark_b
            buffer.mark
          end

          describe "#shift" do
            example do
              expect(buffer.shift).to be == :premark_a
              expect(buffer.shift).to be == :premark_b
              expect(buffer.shift).to be_nil

              buffer.release

              expect(buffer.shift).to be == :premark_a
              expect(buffer.shift).to be == :premark_b
              expect(buffer.shift).to be_nil
            end
          end

          describe "#[]" do
            example do
              buffer.shift
              buffer.shift
              buffer.release

              expect(buffer[0]).to be == :premark_a
              expect(buffer[1]).to be == :premark_b
            end
          end

          describe "#size" do
            example do
              expect { buffer.shift }.to change { buffer.size }.from(2).to(1)
              expect { buffer.shift }.to change { buffer.size }.from(1).to(0)
              expect { buffer.release }.to change { buffer.size }.from(0).to(2)
            end
          end
        end

        context "with two marks" do
          describe "releasing both marks" do
            before(:each) do
              buffer << :a
              buffer << :b
              buffer << :c
              buffer.mark
              buffer.mark
            end

            example do
              output_before_release_1 = [ buffer.shift, buffer.shift, buffer.shift ]
              expect(output_before_release_1).to be == [ :a, :b, :c ]

              buffer.release

              output_before_release_2 = [ buffer.shift, buffer.shift, buffer.shift ]
              expect(output_before_release_2).to be == [ :a, :b, :c ]

              buffer.release

              output_before_release_3 = [ buffer.shift, buffer.shift, buffer.shift ]
              expect(output_before_release_3).to be == [ :a, :b, :c ]
            end
          end

          describe "shifting between the marks" do
            example do
              buffer << :a
              buffer << :b
              buffer.mark
              expect(buffer.shift).to be == :a
              buffer.mark
              expect(buffer.shift).to be == :b
              buffer.release
              expect(buffer.shift).to be == :b
              buffer.release
              expect(buffer.shift).to be == :a
              expect(buffer.shift).to be == :b
            end
          end

          describe "buffering across two marks" do
            before(:each) do
              buffer << :a
              buffer.mark
              buffer << :b
              buffer.mark
              buffer << :c
            end

            example do
              output_before_release_1 = [ buffer.shift, buffer.shift, buffer.shift ]
              expect(output_before_release_1).to be == [ :a, :b, :c ]

              buffer.release

              output_before_release_2 = [ buffer.shift, buffer.shift, buffer.shift ]
              expect(output_before_release_2).to be == [ :a, :b, :c ]

              buffer.release

              output_before_release_3 = [ buffer.shift, buffer.shift, buffer.shift ]
              expect(output_before_release_3).to be == [ :a, :b, :c ]
            end
          end
        end
      end

    end
  end
end
