require_relative '../abstract/context'
require_relative '../main/planner'
require_relative '../menu/sub_menu'
require 'timeout'
require 'io/console'

class PlayersMove < State
  def get_key_timeout(time)
    # puts "get_key_"
    str = ''
    begin
      str = Timeout.timeout(time) { $stdin.getch }
    rescue Timeout::Error
      str = ''
    end
    str
  end

  def do
    @flag_dead = false
    @flag_dead = true if @context.player.dead?
    @key = get_key_timeout 0.01
    @context.flag, @context.enemies = @context.player.do @key, @context.enemies
  end

  def next
    if @flag_dead
      @context.transition_to Menu.new
    elsif @key == 'm'
      @context.transition_to SubMenu.new
    else
      @context.transition_to Planner.new
    end
  end
end
