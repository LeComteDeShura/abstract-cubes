require_relative '../lib/menu/menu'

describe Menu do
  describe "#do" do
    context "stdin.getch \r" do
      it "transition_to Continue" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(Menu.new, player, setting)
        expect(context.state.is_a?(Menu)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(Continue)).to eq true
      end
    end

    context "stdin.getch B\r" do
      it "transition_to NewGame" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(Menu.new, player, setting)
        expect(context.state.is_a?(Menu)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(NewGame)).to eq true
      end
    end

    context "stdin.getch B\r" do
      it "transition_to NewGame" do
        menu = Menu.new
        expect(menu.s_key_timeout(0.001)).to eq ''
      end
    end
  end
end
