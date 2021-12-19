require_relative './app_context'
require_relative '../player/players_move'
require_relative '../enemy/enemies_move'
require_relative '../player/player'
require_relative '../enemy/enemy'

require 'timeout'
require 'io/console'

class Planner < State
  def send_command(command, arg)
    file = File.open(File.expand_path('../pipe/command', __dir__.to_s), 'w')
    file.write("#{command} #{arg}")
    file.close
  end

  def do
    if @context.player.command != ''
      @context.calculate_number_enemies
      @context.spawn_enemies
      @context.update_position_enemies
      send_command @context.player.command, @context.player.angle_x
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
