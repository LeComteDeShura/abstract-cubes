require_relative '../lib/menu/sub_menu'

describe SubMenu do
  describe "#do" do
    context "stdin.getch \r" do
      it "transition_to Planner" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(SubMenu.new, player, setting)
        expect(context.state.is_a?(SubMenu)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(Planner)).to eq true
      end
    end

    context "stdin.getch B\r" do
      it "transition_to SubMenu" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(SubMenu.new, player, setting)
        expect(context.state.is_a?(SubMenu)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(SubMenu)).to eq true
      end
    end

    context "stdin.getch BB\r" do
      it "transition_to Continue" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(SubMenu.new, player, setting)
        expect(context.state.is_a?(SubMenu)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(Continue)).to eq true
      end
    end

    context "stdin.getch BBB\r" do
      it "transition_to Exit" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("B")
        $stdin.should_receive(:getch).and_return("\r")
        context = AppContext.new(SubMenu.new, player, setting)
        expect(context.state.is_a?(SubMenu)).to eq true
        context.do
        context.next
      end
    end
  end
end
