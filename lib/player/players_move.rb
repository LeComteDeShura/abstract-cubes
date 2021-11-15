require_relative '../abstract/context'
require_relative '../main/planner'
require_relative '../menu/sub_menu'
require 'timeout'
require 'io/console'

class PlayersMove < State
  def set_key
    loop do
      user_input = $stdin.getch
      return 'exit' if user_input == 'q'
      return '0' if user_input == '0'
      return 'p' if user_input == 'p'

      case user_input
      when 'A'
        return 'up'
      when 'B'
        return 'down'
      when 'C'
        return 'right'
      when 'D'
        return 'left'
      when 'm'
        return 'menu'
      end
    end
  end

  def get_key_timeout(time)
    # puts "get_key_"
    str = ''
    begin
      str = Timeout.timeout(time) { set_key }
    rescue Timeout::Error
      str = ''
    end
    str
  end

  def do
    exit if @context.player.dead?
    # key = get_key_timeout 0.01
    @key = get_key_timeout 0.01

    # while key != ""
    #     key = get_key_timeout 0.01
    # end
    # p key
    @context.flag, @context.enemies = @context.player.do @key, @context.enemies
  end

  def next
    if @key == "menu"
      @context.transition_to SubMenu.new
    else
      @context.transition_to Planner.new
    end
  end
end
