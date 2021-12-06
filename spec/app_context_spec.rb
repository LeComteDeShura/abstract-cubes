require_relative 'spec_helper'
require_relative '../lib/main/app_context'
require_relative '../lib/menu/menu'
require_relative '../lib/ser_des/config_loader'

describe AppContext do
  before do
    @player, @setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
    @menu = Menu.new
    @context = AppContext.new(@menu, @player, @setting)
  end

  describe "lol" do
    it "puts the ordered book in customer's order history" do
      expect(@context.setting).to eq(@setting)
      expect(@context.state).to eq(@menu)
      expect(@context.player).to eq(@player)
    end
  end

  describe "#calculate_number_enemies" do
    context "give difficult 1" do
      it "return 1" do
        @context.difficult_game = 1
        expect(@context.calculate_number_enemies).to eq(1)
      end
    end

    context "give difficult 12" do
      it "return 2" do
        @context.difficult_game = 12
        expect(@context.calculate_number_enemies).to eq(2)
      end
    end

    context "give difficult 423" do
      it "return 43" do
        @context.difficult_game = 423
        expect(@context.calculate_number_enemies).to eq(43)
      end
    end
  end

  describe "#spawn_enemies" do
    context "is a? Array" do
      it "return true" do
        expect(@context.spawn_enemies.is_a?(Array)).to eq(true)
      end
    end

    context "give difficult 1" do
      it "return length eq 1" do
        expect(@context.spawn_enemies.length).to eq(1)
      end
    end
  end

  describe "#update_position_enemies" do
    context "is a? JSON" do
      it "return true" do
        expect(@context.update_position_enemies.is_a?(Hash)).to eq(true)
      end
    end

    context "give difficult 1" do
      it "return length eq 1" do
        expect(@context.update_position_enemies.length).to eq(1)
      end
    end

    context "render" do
      it "render" do
        expect(@context.render).to eq(nil)
      end
    end
  end
end
