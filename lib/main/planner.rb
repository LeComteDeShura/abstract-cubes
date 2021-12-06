require_relative './app_context'
require_relative '../player/players_move'
require_relative '../enemy/enemies_move'
require_relative '../player/player'
require_relative '../enemy/enemy'

require 'timeout'
require 'io/console'

class Planner < State
  def do
    if @context.player.command != ''
      @context.calculate_number_enemies
      @context.spawn_enemies
      @context.update_position_enemies
      file = File.open(File.expand_path('../pipe/command', __dir__.to_s), 'w')
      file.write("#{@context.player.command} #{@context.player.angle_x}")
      file.close
      exit if @context.player.command == 'exit'
    end
    @context.player.command = ''
    @context.render
  end

  def next
    if @context.flag
      @context.transition_to(PlayersMove.new)
    else
      @context.transition_to(EnemiesMove.new)
    end
  end
end
