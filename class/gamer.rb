# Super class for player and dealer
class Gamer

  attr_accessor :cards, :points, :name

  def retrieve_card(card)
    cards << card
  end

  def show_cards
    img = ""
    cards.each do |card|
      if card.face == 'down'
        img.concat("<img src='/images/cards/cover.jpg'>")
      else
        img.concat("<img src='/images/cards/#{card.suit}_#{card.value}.jpg'>")
      end
    end
    img
  end

  def cal_point
    point = 0
    self.points = []

    cards.each do |card|
      if %w(jack queen king).include?(card.value)
        point += 10
      elsif card.value == 'ace'
        point += 11
      else
        point += card.value.to_i
      end
    end

    points << point if point <= 21

    cards.select { |ele| ele.value == 'ace' }.count.times do
      point -= 10
      points << point if point <= 21
    end
  end

  def has_bj?
    if points.include?(21)
      true
    else
      false
    end
  end

  def is_busted?
    if points.empty?
      true
    else
      false
    end
  end

  def hit

  end
end
