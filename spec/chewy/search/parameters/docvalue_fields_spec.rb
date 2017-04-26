require 'spec_helper'

describe Chewy::Search::Parameters::DocvalueFields do
  subject { described_class.new([:foo, :bar]) }

  describe '#initialize' do
    specify { expect(described_class.new.value).to eq([]) }
    specify { expect(described_class.new(nil).value).to eq([]) }
    specify { expect(described_class.new(:foo).value).to eq(%w(foo)) }
    specify { expect(described_class.new([:foo, nil]).value).to eq(%w(foo)) }
    specify { expect(subject.value).to eq(%w(foo bar)) }
  end

  describe '#replace' do
    specify do
      expect { subject.replace(nil) }
        .to change { subject.value }
        .from(%w(foo bar)).to([])
    end

    specify do
      expect { subject.replace([:foo, :baz]) }
        .to change { subject.value }
        .from(%w(foo bar)).to(%w(foo baz))
    end
  end

  describe '#update' do
    specify do
      expect { subject.update(nil) }
        .not_to change { subject.value }
    end

    specify do
      expect { subject.update([:foo, :baz]) }
        .to change { subject.value }
        .from(%w(foo bar)).to(%w(foo bar baz))
    end
  end

  describe '#merge' do
    specify do
      expect { subject.merge(described_class.new) }
        .not_to change { subject.value }
    end

    specify do
      expect { subject.merge(described_class.new([:foo, :baz])) }
        .to change { subject.value }
        .from(%w(foo bar)).to(%w(foo bar baz))
    end
  end

  describe '#render' do
    specify { expect(described_class.new.render).to be_nil }
    specify { expect(described_class.new(:foo).render).to eq(docvalue_fields: %w(foo)) }
  end
end
