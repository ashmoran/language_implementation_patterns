shared_examples_for "an Enumerator" do
  context "at the start" do
    specify {
      expect(subject.next).to_not be_nil
    }

    specify {
      expect(subject.peek).to_not be_nil
    }

    specify {
      peeked_value = subject.peek
      expect(subject.next).to be == peeked_value
    }
  end

  context "at the end" do
    before(:each) do
      advance_to_end
    end

    specify {
      expect { subject.next }.to raise_error(StopIteration)
    }

    specify {
      expect { subject.peek }.to raise_error(StopIteration)
    }
  end
end
