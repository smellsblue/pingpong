module PingPong
  class Player
    attr_reader :name, :score

    def initialize(name)
      @name = name
      @score = 0
    end

    def serve(ball)
      case do_serve(ball)
      when :let
        PingPong::IO.puts "#{self} has hit the net and will re-serve."
        serve ball
      when :miss
        PingPong::IO.puts "Ohs noes! #{self}'s serve went out!"
        ball.miss!
      else
        PingPong::IO.puts "#{self} serves an awesome shot!"
        ball.hit!
      end
    end

    def hit(ball)
      case do_hit(ball)
      when :miss
        PingPong::IO.puts "D'oh! #{self} hit the ball out!"
        ball.miss!
      else
        PingPong::IO.puts "#{self} whacks the ball."
        ball.hit!
      end
    end

    def score!
      @score += 1
    end

    def to_s
      name
    end

    private
    def do_serve(ball)
      [:let, :miss, :hit].sample
    end

    def do_hit(ball)
      [:miss, :hit].sample
    end
  end
end
