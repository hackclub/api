# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengePostComment, type: :model do
  subject { build(:challenge_post_comment) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :user_id }
  it { should have_db_column :challenge_post_id }
  it { should have_db_column :parent_id }
  it { should have_db_column :body }

  it { should have_db_index :deleted_at }

  it_behaves_like 'Recoverable'

  it { should belong_to :user }
  it { should belong_to(:challenge_post).counter_cache(:comment_count) }
  it { should belong_to :parent }
  it { should have_many :children }

  it { should validate_presence_of :user }
  it { should validate_presence_of :challenge_post }
  it { should validate_presence_of :body }

  context 'with parent' do
    before { subject.parent = build(:challenge_post_comment) }

    it "requires challenge_post to match parent's" do
      expect(subject.valid?).to eq(false)
      expect(subject.errors).to include(:parent)

      subject.parent.challenge_post = subject.challenge_post

      expect(subject.valid?).to eq(true)
    end
  end

  describe '#notify_post_creator' do
    context 'when comment is not by creator' do
      subject { build(:challenge_post_comment, user: build(:user)) }

      it 'notifies' do
        expect(ChallengePostCommentMailer.deliveries.length).to eq(0)

        perform_enqueued_jobs do
          subject.save
        end

        expect(ChallengePostCommentMailer.deliveries.length).to eq(1)
      end
    end

    context 'when comment is by creator' do
      subject do
        comment = build(:challenge_post_comment)
        comment.user = comment.challenge_post.creator

        comment
      end

      it 'does not notify' do
        expect(ChallengePostCommentMailer.deliveries.length).to eq(0)

        perform_enqueued_jobs do
          subject.save
        end

        expect(ChallengePostCommentMailer.deliveries.length).to eq(0)
      end
    end
  end
end
