require_relative '../abstract/context'
require_relative '../main/planner'
require_relative '../menu/sub_menu'
require_relative '../menu/continue'
require 'timeout'
require 'io/console'

class SubMenu < State
  def initialize
    super()
    @index = 1
    @flag_save = false
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
    print "\e[48;2;255;90;0m" if @index == 1
    print "продолжить игру\n\e[48;2;0;0;0m"
    print "\e[48;2;255;90;0m" if @index == 2
    print "сохранить игру\n\e[48;2;0;0;0m"
    print "\e[48;2;255;90;0m" if @index == 3
    print "загрузить игру\n\e[48;2;0;0;0m"
    print "\e[48;2;255;90;0m" if @index == 4
    print "выход\n\e[48;2;0;0;0m"
    print "\nИГРА СОХРАНЕНА в #{@context.name_save}" if @flag_save
  end

  def do
    print "\e[48;2;0;0;0m"
    system 'clear'

    key = ''
    while key != "\n"
      @index = [@index - 1, 1].max if key == 'up'
      @index = [@index + 1, 4].min if key == 'down'

      key = s_key_timeout 0.01

      exit if key == 'q'

      print_menu
    end
  end

  def next
    case @index
    when 1
      @context.transition_to Planner.new
    when 2
      saver = GameSaver.new @context.name_save, @context.player, @context.setting
      saver.save
      @flag_save = true
    when 3
      @context.transition_to Continue.new('submenu')
    when 4
      saver = GameSaver.new @context.name_save, @context.player, @context.setting
      saver.save
      exit
    end
  end
end
