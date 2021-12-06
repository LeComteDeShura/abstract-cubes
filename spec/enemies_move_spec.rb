describe EnemiesMove do
  describe "#do" do
    context "stdin.getch m\r" do
      it "transition_to SubMenu" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        context = AppContext.new(EnemiesMove.new, player, setting)
        expect(context.state.is_a? EnemiesMove).to eq true
        context.do
        context.next
        expect(context.state.is_a? Planner).to eq true
      end
    end
  end
end
