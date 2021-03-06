module PingPong
  class Game
    attr_reader :player1, :player2, :current_player

    def initialize(player1 = nil, player2 = nil)
      @player1 = player1 || new_player(1)
      @player2 = player2 || new_player(2)
      @current_player = @player1
    end

    def coin_flip!
      PingPong::IO.puts "Press Enter for coin flip"
      PingPong::IO.gets
      @current_player = [player1, player2].sample
      PingPong::IO.puts "#{current_player} has won the toss!"
    end

    def round!
      PingPong::IO.puts "Press Enter to serve as #{current_player}"
      PingPong::IO.gets
      ball = PingPong::Ball.new current_player
      current_player.serve ball

      until ball.missed?
        ball.possessor = other_player ball.possessor
        ball.possessor.hit ball
      end

      other_player(ball.possessor).score!
      PingPong::IO.puts score_message

      if player1.score >= 20 && player2.score >= 20
        change_possession!
      elsif total_score % 5 == 0
        change_possession!
      end
    end

    def score_message
      if player1.score >= 20 && player2.score >= 20 && !has_winner?
        if player1.score == player2.score
          "The score is DEUCE (#{player1}: #{player1.score} - #{player2}: #{player2.score})"
        else
          "The score is ADVANTAGE #{winning_player} (#{player1}: #{player1.score} - #{player2}: #{player2.score})"
        end
      else
        "The score is #{player1}: #{player1.score} - #{player2}: #{player2.score}"
      end
    end

    def winner
      return nil unless has_winner?
      [player1, player2].max_by(&:score)
    end

    def winning_player
      return nil if player1.score == player2.score
      [player1, player2].max_by(&:score)
    end

    def has_winner?
      is_winner?(player1, player2) || is_winner?(player2, player1)
    end

    def total_score
      player1.score + player2.score
    end

    def other_player(player = nil)
      player = current_player unless player

      if player == player1
        player2
      else
        player1
      end
    end

    private
    def new_player(num)
      PingPong::IO.puts "What is player #{num}\'s name?"
      PingPong::Player.new PingPong::IO.gets.strip
    end

    def is_winner?(p1, p2)
      p1.score >= 21 && p1.score - p2.score >= 2
    end

    def change_possession!
      @current_player = other_player
    end
  end
end
