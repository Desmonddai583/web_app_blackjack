require_relative 'dealer'
require_relative 'player'
require_relative 'deck'

# Blackjack Game
class BlackJack
  attr_accessor :player, :dealer, :deck, :minimum_bet, :has_init

  def initialize(name, chips, deck_num, min_bet)
    @player = Player.new(name, chips)
    @dealer = Dealer.new
    @deck = set_deck(deck_num)
    @minimum_bet = min_bet
    @has_init = false
  end

  def set_deck(num)
    self.deck = Deck.new(num)
  end

  # Deal first two cards
  def init_deal
    unless self.has_init
      card = {}
      2.times do |index|
        player.retrieve_card(deck.deal_card)
        if index == 1
          card = deck.deal_card
          card.face = 'down'
          dealer.retrieve_card(card)
        else
          dealer.retrieve_card(deck.deal_card)
        end
      end
      self.has_init = true
    end
    dealer.cal_point
    player.cal_point
  end

  def insurance?
    dealer.has_ten_plus?
  end

  def check_insurance
    if self.player.has_insurance
      if self.dealer.has_bj?
        if self.player.has_bj?
          self.player.tie?('bj_insurance')
        else
          self.player.lose?('insurance')
        end
      else
        if self.player.has_bj?
          self.player.won?('bj_insurance')
        else
          "Dealer does not hit Blackjack. #{self.player.name} lose insurance.
           Round continues."
        end
      end
    else
      if self.dealer.has_bj?
        if self.player.has_bj?
          self.player.tie?('bj')
        else
          self.player.lose?('bj')
        end
      else
        if self.player.has_bj?
          self.player.won?('blackjack')
        else
          if insurance?
            'Dealer does not hit Blackjack. Round continues.'
          else
            ''
          end
        end
      end
    end
  end

  # Compare total points of gamers
  def compare_points
    player_point = player.points.sort.last
    dealer_point = dealer.points.sort.last
    if player_point > dealer_point
      player.won?('points')
    elsif player_point < dealer_point
      player.lose?('points')
    else
      player.tie?('points')
    end
  end

  # Reset all status before a new round
  def reset
    dealer.cards = []
    dealer.points = []
    player.cards = []
    player.points = []
    player.bet_chips = 0
    player.has_insurance = false
    player.is_complete = false
    self.has_init = false
  end
end
