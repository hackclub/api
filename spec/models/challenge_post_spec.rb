# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengePost, type: :model do
  subject { build(:challenge_post) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :name }
  it { should have_db_column :url }
  it { should have_db_column :description }
  it { should have_db_column :creator_id }
  it { should have_db_column :challenge_id }
  it { should have_db_column :click_count }
  it { should have_db_column :comment_count }

  it_behaves_like 'Recoverable'

  it { should belong_to :creator }
  it { should belong_to :challenge }
  it { should have_many(:upvotes).dependent(:destroy) }
  it { should have_many(:clicks).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_presence_of :creator }
  it { should validate_presence_of :challenge }

  it 'should not be able to be created before challenge starts' do
    subject.challenge = build(:challenge, start: 1.day.from_now)

    expect(subject.save).to eq(false)
  end

  it 'should not be able to be created after challenge ends' do
    subject.challenge = build(:challenge, end: 1.day.ago)

    expect(subject.save).to eq(false)
  end

  describe '#url_redirect' do
    it 'returns nil when url is not persisted' do
      expect(subject.url_redirect).to be_nil
    end

    context 'after persistence' do
      before { subject.save }
      it 'returns redirect url' do
        expect(subject.url_redirect). to include(
          "/v1/posts/#{subject.id}/redirect"
        )
      end
    end
  end

  describe '#click_count' do
    it 'returns 0' do
      expect(subject.click_count).to eq(0)
    end

    context 'with clicks' do
      before do
        5.times do
          ChallengePostClick.create(
            challenge_post: subject,
            ip_address: '127.0.0.1'
          )
        end
      end

      it 'returns the correct amount' do
        expect(subject.click_count).to eq(5)
      end
    end
  end

  describe '#comment_count' do
    it 'returns 0' do
      expect(subject.comment_count).to eq(0)
    end

    context 'with comments' do
      before do
        5.times do
          create(:challenge_post_comment, challenge_post: subject)
        end
      end

      it 'returns the correct amount' do
        expect(subject.comment_count).to eq(5)
      end
    end
  end

  describe '#rank_score' do
    it 'returns nil when not persisted' do
      expect(subject.rank_score).to eq(nil)
    end

    context 'when persisted' do
      before { subject.save }

      it 'returns a lower value than an instance with lots of upvotes' do
        upvoted = create(:challenge_post_with_upvotes, upvote_count: 10)

        expect(subject.rank_score).to be <= upvoted.rank_score
      end
    end
  end
end
