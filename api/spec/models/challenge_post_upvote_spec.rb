# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengePostUpvote, type: :model do
  subject { build(:challenge_post_upvote) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :challenge_post_id }
  it { should have_db_column :user_id }

  it_behaves_like 'Recoverable'

  it { should belong_to :challenge_post }
  it { should belong_to :user }

  it { should validate_presence_of :challenge_post }
  it { should validate_presence_of :user }

  it "shouldn't allow two upvotes to be created for same user and post" do
    post = create(:challenge_post)
    user = create(:user)

    # first upvote
    upvote = ChallengePostUpvote.new(challenge_post: post, user: user)
    expect(upvote.save).to eq(true)

    # second upvote
    dupe = ChallengePostUpvote.new(challenge_post: post, user: user)
    expect(dupe.save).to eq(false)
  end

  it "shouldn't allow upvotes to be created before challenges start" do
    challenge = create(:challenge, start: 1.day.from_now)
    post = create(:challenge_post, challenge: challenge)
    subject.challenge_post = post

    expect(subject.save).to eq(false)
  end

  it "shouldn't allow upvotes to be created after challenges end" do
    challenge = create(:challenge, end: 1.day.ago)
    post = create(:challenge_post, challenge: challenge)
    subject.challenge_post = post

    expect(subject.save).to eq(false)
  end
end
