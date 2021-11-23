require_relative '../lib/menu/sub_menu'


describe SubMenu do
  describe "#do" do
    context "give difficult 1" do
      it "return 1" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        context = AppContext.new(SubMenu.new, player, setting)
        context.do
        displayer.stub(:getch).and_return("123\n")
      end
  end

  describe "#s_key" do
  end
end
