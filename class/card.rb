# Card object
class Card
  attr_accessor :suit, :value, :face

  def initialize(suit, value)
    @suit = suit
    @value = value
    @face = 'up'
  end

  def card_info
    self.suit + " " + self.value
  end
end
