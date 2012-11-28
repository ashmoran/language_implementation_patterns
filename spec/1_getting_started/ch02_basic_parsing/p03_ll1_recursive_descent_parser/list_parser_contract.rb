shared_examples_for "a ListParser" do
  # The example in the book (deliberately?) avoids this case, but it's an obvious
  # TDD bootstrapping case, and turned out to be not too difficult to implement
  # compared to the Java example
  context "empty list" do
    let(:token_descriptions) {
      [
        { lbrack: "[" },
        { rbrack: "]" },
        { eof:    nil }
      ]
    }

    specify {
      expect(parser.list).to be == [ ]
    }
  end

  context "list with a name" do
    let(:token_descriptions) {
      [
        { lbrack: "[" },
        { name:   "a" },
        { rbrack: "]" },
        { eof:    nil }
      ]
    }

    specify {
      expect(parser.list).to be == [ :a ]
    }
  end

  context "list with a multiple names" do
    let(:token_descriptions) {
      [
        { lbrack: "[" },
        { name:   "a" },
        { comma:  "," },
        { name:   "b" },
        { comma:  "," },
        { name:   "c" },
        { rbrack: "]" },
        { eof:    nil }
      ]
    }

    specify {
      expect(parser.list).to be == [ :a, :b, :c ]
    }
  end

  context "list of lists" do
    let(:token_descriptions) {
      [
        { lbrack: "[" },
          { name:   "a" },
          { comma:  "," },
            { lbrack: "[" },
              { name:   "x" },
              { comma:  "," },
              { name:   "y" },
            { rbrack: "]" },
          { comma:  "," },
          { name:   "b" },
        { rbrack: "]" },
        { eof:    nil }
      ]
    }

    specify {
      expect(parser.list).to be == [ :a, [ :x, :y ], :b ]
    }
  end

  context "empty list in a list" do
    let(:token_descriptions) {
      [
        { lbrack: "[" },
          { name:   "a" },
          { comma:  "," },
            { lbrack: "[" },
            { rbrack: "]" },
          { comma:  "," },
          { name:   "b" },
        { rbrack: "]" },
        { eof:    nil }
      ]
    }

    specify {
      expect(parser.list).to be == [ :a, [ ], :b ]
    }
  end

  context "list of list of lists to prove to Bobby my code really works" do
    let(:token_descriptions) {
      [
        { lbrack: "[" },
          { name:   "a" },
          { comma:  "," },
            { lbrack: "[" },
              { name:   "x" },
              { comma:  "," },
                { lbrack: "[" },
                  { name:   "i" },
                  { comma:  "," },
                  { name:   "j" },
                { rbrack: "]" },
            { rbrack: "]" },
          { comma:  "," },
          { name:   "b" },
        { rbrack: "]" },
        { eof:    nil }
      ]
    }

    specify {
      expect(parser.list).to be == [ :a, [ :x, [ :i, :j ] ], :b ]
    }
  end

  context "invalid input" do
    context "no list" do
      let(:token_descriptions) {
        [
          { eof: nil }
        ]
      }

      specify {
        expect { parser.list }.to raise_error(ArgumentError, "Expected :lbrack, found :eof")
      }
    end

    context "unclosed list" do
      let(:token_descriptions) {
        [
          { lbrack: "[" },
          { eof:    nil }
        ]
      }

      specify {
        expect { parser.list }.to raise_error(
          ArgumentError, "Expected :lbrack, :name or :rbrack, found :eof"
        )
      }
    end

    context "missing name before a comma" do
      let(:token_descriptions) {
        [
          { lbrack: "[" },
          { comma:  "," },
          { rbrack: "]" },
          { eof:    nil }
        ]
      }

      specify {
        expect { parser.list }.to raise_error(
          ArgumentError, "Expected :lbrack, :name or :rbrack, found :comma"
        )
      }
    end

    context "missing name after a comma" do
      let(:token_descriptions) {
        [
          { lbrack: "[" },
          { name:   "a" },
          { comma:  "," },
          { rbrack: "]" },
          { eof:    nil }
        ]
      }

      specify {
        expect { parser.list }.to raise_error(
          ArgumentError, "Expected :name or :lbrack, found :rbrack"
        )
      }
    end
  end
end