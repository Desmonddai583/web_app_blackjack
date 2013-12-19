require_relative 'card'

# Deck object
class Deck
  attr_accessor :cards, :deck_num

  @@values = %w(2 3 4 5 6 7 8 9 10 jack queen king ace)
  @@suits = %w(spades hearts diamonds clubs)

  def initialize(deck_num)
    @deck_num = deck_num
    @cards = shuffle_cards
  end

  def shuffle_cards
    cards = []

    deck_num.times do
      @@suits.each do |suit|
        @@values.each do |value|
          cards << Card.new(suit, value)
        end
      end
    end

    cards.shuffle!
  end

  # Regenerate and shuffle if cards less than half, precautian for counting cards
  def check_cards?
    total_cards = deck_num * 52
    current_cards = cards.count
    if current_cards <= (total_cards / 2)
      self.cards = shuffle_cards
      true
    else
      false
    end
  end

  def deal_card
    cards.pop
  end
end
