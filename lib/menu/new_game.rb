require_relative '../main/planner'
require_relative '../abstract/context'
require_relative '../ser_des/game_saver'
require 'timeout'
require 'io/console'

class NewGame < State
  def do
    print "\e[48;2;0;0;0m"
    system 'clear'

    print "Введите имя сохранения: "
    @context.name_save = $stdin.gets.to_s.chomp

    GameSaver.new(@context.name_save, @context.player, @context.setting).save
  end

  def next
    @context.transition_to(Planner.new)
  end
end
