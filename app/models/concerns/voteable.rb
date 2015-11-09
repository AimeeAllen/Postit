module Voteable
  def number_of_up_votes
    self.votes.where(vote: true).size
  end

  def number_of_down_votes
    self.votes.where(vote: false).size
  end

  def number_of_votes
    number_of_up_votes - number_of_down_votes
  end
end
