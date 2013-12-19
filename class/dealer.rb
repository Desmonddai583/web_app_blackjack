require_relative 'gamer'

# Dealer object
class Dealer < Gamer
  def initialize
    @cards = []
    @points = []
    @name = 'Dealer'
  end

  # Check whether dealer can ask insurance to players
  def has_ten_plus?
    if %w(jack queen king ace 10).include?(cards[0].value)
      true
    else
      false
    end
  end

  # Check all of cards on dealer's hand include face down one
  def reveal_card
    cards[1].face = 'up'
  end
end
