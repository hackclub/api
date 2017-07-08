class ClubApplicationSpamService
  WORD_CUTOFF = 5

  def spam?(application)
    word_count(application.interesting_project) <= WORD_CUTOFF ||
      word_count(application.systems_hacked) <= WORD_CUTOFF
  end

  private

  def word_count(str)
    str.split(' ').count
  end
end
