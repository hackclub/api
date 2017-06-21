require 'rails_helper'

module Hackbot
  RSpec.describe CodeFormatterService do
    # Define input in subblocks
    subject(:result) do
      CodeFormatterService.new(input).format
    end

    context 'when given an empty string' do
      let(:input) { '' }

      it { should eq "```\n```" }
    end

    context 'when given a regular string' do
      let(:input) { "foo bar\nbar foo" }

      it { should eq "```\nfoo bar\nbar foo\n```" }
    end

    context 'when given a string with leading new lines' do
      let(:input) { "\nfoo" }

      it { should eq "```\nfoo\n```" }
    end

    context 'when given a string with trailing new lines' do
      let(:input) { "foo\n" }

      it { should eq "```\nfoo\n```" }
    end

    context 'when given string that exceeds the character limit' do
      let(:input) { "foo\nbar" * 10_000 }

      it { should include '...truncated...' }
    end
  end
end
