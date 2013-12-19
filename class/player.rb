require_relative 'gamer'

# Player Object
class Player < Gamer
  attr_accessor :chips, :bet_chips, :cards, :points, :has_insurance, :is_complete

  def initialize(name, chips)
    @cards = []
    @points = []
    @name = name
    @chips = chips
    @bet_chips = 0
    @has_insurance = false
    @is_complete = false
  end

  def buy_insurance()
    if self.chips < self.bet_chips
      false
    else
      self.bet_chips /= 2
      self.has_insurance = true
      true
    end
  end

  def won?(status)
    if status == 'blackjack'
      won_with_bj
    elsif status == 'bj_insurance'
      won_with_bj_insurance
    elsif status == 'busted'
      won_with_busted
    elsif status == 'points'
      won_with_points
    end
  end

  # Push situiation
  def tie?(status)
    if status == 'points'
      tie_with_points
    elsif status == 'bj_insurance'
      tie_with_bj_insurance
    elsif status == 'bj'
      tie_with_bj
    end
  end

  # Lose situiation
  def lose?(status)
    if status == 'points'
      lose_with_points
    elsif status == 'busted'
      lose_with_busted
    elsif status == 'insurance'
      lose_with_insurance
    elsif status == 'bj'
      lose_with_bj
    end
  end

  # Dealer busted
  def won_with_busted
    self.chips += 2 * self.bet_chips
    self.is_complete = true
    "Dealer is busted, Win for player!"
  end

  # Player buy insurance with hitting Blackjack
  def tie_with_bj_insurance
    self.chips += 3 * self.bet_chips
    self.is_complete = true
    "Dealer hit Blackjack. #{name} hit Blackjack too! A push for #{name}.
     #{name} bought an insurance. Pay 2 times of insurance."
  end

  # Player buy insurance without hitting Blackjack
  def lose_with_insurance
    self.chips += 2 * self.bet_chips
    self.is_complete = true
    "Dealer hit Blackjack. A lose for #{name}
     #{name} bought an insurance. Pay 2 times of insurance."
  end

  def won_with_bj_insurance
    self.chips += self.bet_chips * 2.5
    self.is_complete = true
    "Dealer does not hit blackjack. #{name} lose insurance.
     #{name} hit Blackjack! Pay 2.5 times of bet_chips. Win for #{name}."
  end

  # Both of player and gamer hit Blackjack
  def tie_with_bj
    self.chips += self.bet_chips
    self.is_complete = true
    "#{name} hit Blackjack! Dealer hit Blackjack too. Push for #{name}."
  end

  def lose_with_bj
    self.is_complete = true
    "Dealer hit Blackjack. #{name} lose bet. Lose for #{name}"
  end

  def won_with_bj
    self.chips += self.bet_chips * 2.5
    self.is_complete = true
    "Dealer does not hit blackjack. #{name} hit Blackjack! Pay 2.5 times of bet_chips. Win for #{name}"
  end

  # Player busted
  def lose_with_busted
    self.is_complete = true
    "#{name} is busted. Lose for #{name}"
  end

  # Player get larger point than dealer
  def won_with_points
    self.chips += 2 * self.bet_chips
    self.is_complete = true
    "#{name}'s point is bigger than dealer! #{name} get extra one bet. Win for #{name}"
  end

  # Player get smaller point than dealer
  def lose_with_points
    self.is_complete = true
    "#{name}'s point is smaller than dealer! #{name} lose bet. Lose for #{name}"
  end

  # Player gets same point as dealer gets
  def tie_with_points
    self.chips += self.bet_chips
    self.is_complete = true
    "#{name}'s point is same as dealer! Push for #{name}."
  end

  # Check whether player has enough chips to play
  # if not, player out of game
  def broke?(minimum_bet)
    if self.chips < minimum_bet
      true
    else
      false
    end
  end


end
