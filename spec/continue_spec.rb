require_relative '../lib/menu/sub_menu'

describe Continue do
  describe "#do" do
    context "stdin.getch \r" do
      it "transition_to Planner" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(Continue.new, player, setting)
        expect(context.state.is_a?(Continue)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(Planner)).to eq true
      end
    end

    context "stdin.getch \r" do
      it "transition_to Planner" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(Continue.new("submenu"), player, setting)
        expect(context.state.is_a?(Continue)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(SubMenu)).to eq true
      end
    end

    context "stdin.getch \r" do
      it "transition_to Planner" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(Continue.new(), player, setting)
        expect(context.state.is_a?(Continue)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(Menu)).to eq true
      end
    end
  end
end