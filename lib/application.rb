require_relative './main/planner'
require_relative './main/app_context'
require_relative './menu/menu'
require_relative './ser_des/config_loader'

class Application
  def run
    player, setting = ConfigLoader.load(File.expand_path('../saves/base', __dir__.to_s))
    context = AppContext.new(Menu.new, player, setting)
    loop do
      context.do
      context.next
    end
  end
end
