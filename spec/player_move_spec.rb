describe PlayersMove do
  describe "#do" do
    context "stdin.getch m\r" do
      it "transition_to SubMenu" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("m")
        context = AppContext.new(PlayersMove.new, player, setting)
        expect(context.state.is_a?(PlayersMove)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(SubMenu)).to eq true
      end
    end

    context "stdin.getch 0\r" do
      it "transition_to Planner" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        $stdin.should_receive(:getch).and_return("B")
        context = AppContext.new(PlayersMove.new, player, setting)
        expect(context.state.is_a?(PlayersMove)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(Planner)).to eq true
      end
    end
  end
end
