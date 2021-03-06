require_relative '../abstract/context'
require_relative '../main/planner'

class EnemiesMove < State
  def do
    @context.enemies.each do |enemy|
      @context.flag = enemy.do @context.player.position
      @context.player.take_damage enemy.power unless @context.flag

      @context.flag = true

      if enemy.dead?
        @context.enemies.delete enemy
        @context.difficult_game += 1
      end
    end
  end

  def next
    @context.transition_to Planner.new
  end
end
