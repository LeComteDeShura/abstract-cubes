require_relative '../main/planner'
require_relative '../abstract/context'
require_relative '../menu/new_game'
require_relative '../menu/continue'
require 'timeout'
require 'io/console'

# person

class Menu < State
  def initialize
    super()
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
    print "\e[48;2;255;90;0m" if @index == 1
    print "продолжить\n"
    print "\e[48;2;0;0;0m"
    print "\e[48;2;255;90;0m" if @index == 2
    print "новая игра\n"
    print "\e[48;2;0;0;0m"
    print "\e[48;2;255;90;0m" if @index == 3
    print "выход\n"
    print "\e[48;2;0;0;0m"
  end

  def do
    print "\e[48;2;0;0;0m"
    system 'clear'

    key = ''
    while key != "\n"
      @index = [@index - 1, 1].max if key == 'up'
      @index = [@index + 1, 3].min if key == 'down'

      key = s_key_timeout 0.01

      exit if key == 'q'

      print_menu
    end
  end

  def next
    case @index
    when 1
      system "clear"
      @context.transition_to(Continue.new)
    when 2
      @context.transition_to(NewGame.new)
    when 3
      system 'clear'
      exit
    end
  end
end

# print "\e[48;2;255;0;255m"
