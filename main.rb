require_relative 'class/player'
require_relative 'class/dealer'
require_relative 'class/deck'
require_relative 'class/blackjack'
require 'rubygems'
require 'sinatra'
require 'pry'

enable :sessions

helpers do
  def check_minimum_bet(minimum)
    if minimum.to_i.to_s != minimum
      @error = 'Minimum bet must be integers!'
      false
    elsif minimum.to_i < 10
      @error = 'Minimum bet can not be less than 10!'
      false
    else
      true
    end
  end

  def check_player_name(player_name)
    if player_name == 'dealer'
      @error = 'Name can not be dealer!'
      false
    elsif !player_name.empty?
      true
    else
      @error = 'Name can not be null!'
      false
    end
  end

  def check_player_chips(player_chip)
    if player_chip.to_i.to_s != player_chip
      @error = "Player's chips must be digits!"
      false
    elsif player_chip.to_i < params[:min_bet].to_i
      @error = "Player's chips can not be less than minimum bet!"
      false
    else
      true
    end
  end

  def check_bet_chips(bet_chips)
    if bet_chips.to_i.to_s != bet_chips
      @error = 'Bet chips must be integers!'
      false
    elsif bet_chips.to_i < session[:bj].minimum_bet
      @error = "Bet chips can not be less than #{session[:bj].minimum_bet}!"
      false
    elsif bet_chips.to_i > session[:bj].player.chips
      @error = 'You do not have enough chips to bet!'
      false
    elsif bet_chips.to_i % 10 != 0
      @error = 'The minimum unit of your bet should be 10.(Such as 20,30...)'
      false
    else
      true
    end
  end
end

get '/' do
  erb :init
end

post '/init' do
  unless check_minimum_bet(params[:min_bet]) then halt erb :init end
  unless check_player_name(params[:player_name]) then halt erb :init end
  unless check_player_chips(params[:player_chip]) then halt erb :init end
  @bj = BlackJack.new(params[:player_name], params[:player_chip].to_i, params[:deck_num].to_i, params[:min_bet].to_i)
  session[:bj] = @bj
  redirect '/bet'
end

get '/bet' do
  erb :bet
end

post '/bet' do
  unless check_bet_chips(params[:bet_chips]) then halt erb :bet end
  session[:bj].player.chips -= params[:bet_chips].to_i
  session[:bj].player.bet_chips = params[:bet_chips].to_i
  session[:bj].init_deal
  if session[:bj].insurance?
    redirect '/insurance'
  else
    redirect '/game'
  end
end

get '/insurance' do
  erb :insurance
end

get '/game' do
  session[:result_info] = session[:bj].check_insurance
  session[:turn] = 'player'
  erb :game
end

post '/game' do
  if params[:insurance] == 'yes'
    unless session[:bj].player.buy_insurance
      @error = "You do not have enough chips to buy insurance!"
      halt erb :insurance
    end
    session[:bj].dealer.reveal_card
  end
  redirect '/game'
end

post '/game/player/hit' do
  session[:result_info] = ''
  session[:bj].player.retrieve_card(session[:bj].deck.deal_card)
  session[:bj].player.cal_point
  if session[:bj].player.is_busted?
    session[:result_info] = session[:bj].player.lose?('busted')
  end
  erb :game
end

post '/game/player/stay' do
  session[:turn] = 'dealer'
  session[:bj].dealer.reveal_card
  redirect '/game/dealer'
end

get '/game/dealer' do
  session[:stay] = false
  if session[:bj].dealer.points.sort.last >= 17
    session[:stay] = true
  end
  erb :game
end

post '/game/dealer/hit' do
  session[:result_info] = ''
  session[:bj].dealer.retrieve_card(session[:bj].deck.deal_card)
  session[:bj].dealer.cal_point
  if session[:bj].dealer.is_busted?
    session[:result_info] = session[:bj].player.won?('busted')
  else
    if session[:bj].dealer.points.sort.last >= 17
      session[:stay] = true
    end
  end
  erb :game
end

post '/game/dealer/stay' do
  session[:result_info] = ''
  session[:result_info] = session[:bj].compare_points
  erb :game
end

get '/new_round' do
  if session[:bj].player.broke?(session[:bj].minimum_bet)
    session[:info] = "You chips are not enough, you are out previous game."
    session[:bj] = nil
    redirect "/"
  else
    session[:bj].reset
    if session[:bj].deck.check_cards?
      @info = "Decks' cards less than half, reshuffle new decks!"
    end
    redirect '/bet'
  end

end

get '/restart' do
  session[:bj] = nil
  redirect "/"
end

get '/resume' do
  unless session[:bj].has_init
    redirect '/bet'
  else
    erb :game
  end
end
