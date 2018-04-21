# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'Recoverable' do
  let(:model) { described_class }

  it 'allows recovery of deleted instances' do
    subject.save! unless subject.persisted?

    id = subject.id

    subject.destroy

    expect(model.find_by(id: id)).to eq(nil)

    model.with_deleted.find_by(id: id).restore

    expect(model.find_by(id: id)).to_not eq(nil)
  end
end
