# frozen_string_literal: true

class ClubApplicationSpamService
  WORD_CUTOFF = 5

  def spam?(application)
    return false if application.interesting_project.nil? ||
                    application.systems_hacked.nil?

    word_count(application.interesting_project) <= WORD_CUTOFF ||
      word_count(application.systems_hacked) <= WORD_CUTOFF
  end

  private

  def word_count(str)
    str.split(' ').count
  end
end
