# frozen_string_literal: true

class ChallengePostComment < ApplicationRecord
  include Recoverable

  belongs_to :user
  belongs_to :challenge_post, counter_cache: :comment_count
  belongs_to :parent, class_name: 'ChallengePostComment'

  has_many :children,
           class_name: 'ChallengePostComment',
           foreign_key: 'parent_id'

  validates :user, :challenge_post, :body, presence: true

  validate :parent_challenge_post_matches_challenge_post

  after_commit :notify_post_creator, on: :create

  def parent_challenge_post_matches_challenge_post
    return unless parent
    return if parent.challenge_post == challenge_post

    errors.add(:parent, "parent's challenge_post must match")
  end

  def notify_post_creator
    return if user == challenge_post.creator
    return if user.shadow_banned?
    return unless challenge_post.creator.email_on_new_challenge_post_comments

    ChallengePostCommentMailer
      .with(comment: self)
      .notify_post_creator
      .deliver_later
  end
end
