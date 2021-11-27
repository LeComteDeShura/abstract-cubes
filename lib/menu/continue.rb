require_relative '../main/planner'
require_relative '../abstract/context'
require_relative '../ser_des/game_loader'
require_relative '../menu/new_game'
require_relative '../menu/sub_menu'
require 'timeout'
require 'io/console'

class Continue < State
  def initialize(statenext = "menu")
    super()
    @statenext = statenext
    @name_saves = name_saves
    @max_index = @name_saves.length
    @index = 1
  end

  def s_key
    loop do
      user_input = $stdin.getch
      case user_input
      when 'q'
        exit
      when "\r"
        return "\n"
      else
        case user_input
        when 'A'
          return 'up'
        when 'B'
          return 'down'
        end
      end
    end
    ''
  end

  def s_key_timeout(time)
    str = ''
    begin
      str = Timeout.timeout(time) { s_key }
    rescue Timeout::Error
      str = ''
    end
    $stdout.flush
    $stdin.flush
    str
  end

  def print_menu
    print "\e[1;1H"
    print "Выберите сохранение\n\n"

    (1..@max_index).each do |i|
      print "\e[48;2;255;90;0m" if @index == i
      print "#{i}) #{@name_saves[i - 1]}\n\e[48;2;0;0;0m"
    end

    print "\e[48;2;255;90;0m" if @index == @max_index + 1
    print "\nназад\e[48;2;0;0;0m"
    print "\n #{@name_saves[@index - 1]}"
  end

  def name_saves
    dir = '../../saves/*'
    dir = File.expand_path(dir, __dir__.to_s)
    path_name_saves = Dir[dir].select { |file| File.directory?(file) }
    name_saves = path_name_saves.map { |string| string.slice(dir.size - 1..string.length) }
    name_saves.delete('base')
    name_saves
  end

  def do
    print "\e[48;2;0;0;0m"
    system 'clear'

    key = ''
    while key != "\n"
      @index = [@index - 1, 1].max if key == 'up'
      @index = [@index + 1, @max_index + 1].min if key == 'down'

      key = s_key_timeout 0.01

      exit if key == 'q'

      print_menu
    end
  end

  def next
    if @index <= @max_index
      loader = GameLoader.new @name_saves[@index - 1]
      player, setting, enemies = loader.load
      # @context.name_save = @name_saves[@index-1]
      @context.load(player, setting, enemies, @name_saves[@index - 1])
      @context.transition_to(Planner.new)
    elsif @statenext == 'submenu'
      @context.transition_to(SubMenu.new)
    else
      @context.transition_to(Menu.new)
    end
  end
end
