require_relative 'spec_helper'
require_relative '../lib/player/player'

describe Player do
  describe '.new' do
    context 'without args' do
      subject { Player.new }

      it { expect(subject.health).to eq 100 }
      it { expect(subject.power).to eq 10 }
      it { expect(subject.position).to eq Vector[0, 0, 0] }
      it { expect(subject.angle_rotation).to eq 1.57 }
      it { expect(subject.ray_direction).to eq Vector[1, 0, 0] }
    end
    context 'with arg' do
      subject do
        Player.new health = 1000,
                   power = -20,
                   position = Vector[0, 0, 0],
                   angle_rotation = 0.02
      end

      it { expect(subject.health).to eq 100 }
      it { expect(subject.power).to eq 1 }
      it { expect(subject.position).to eq Vector[0, 0, 0] }
      it { expect(subject.angle_rotation).to eq 0.02 }
    end
  end

  describe '#dead?' do
    context 'health > 0' do
      let(:player) { Player.new(health = 10) }
      it { expect(player.dead?).to be false }
    end

    context 'health <= 0' do
      it {
        player = Player.new
        player.health = -10
        expect(player.dead?).to eq true
      }
    end
  end

  describe "#trans" do
    context 'angle = 123 rad' do
      let(:player) { Player.new }
      it {
        player.angle_x = 123
        expect(player.trans).to eq Vector[-0.89, -0.46, 0]
      }
    end

    context 'angle = 6.28 rad' do
      let(:player) { Player.new }
      it {
        player.angle_x = 6.28
        expect(player.trans).to eq Vector[1, 0, 0]
      }
    end
  end

  describe "#take_damage" do
    context 'health = 100, damage = 10' do
      let(:player) { Player.new health = 100 }
      it {
        expect(player.take_damage(10)).to eq 90
      }
    end
  end

  describe "#sph_intersect" do
    context 'ray direction = [1,0,0], position enemy= [10,0,0]' do
      let(:player) { Player.new }
      it {
        expect(player.intersect_enemy(Vector[10, 0, 0])).to eq Vector[9.5, 10.5]
      }
    end
  end

  describe "#do" do
    context 'key = \'exit\', enemies = nil' do
      let(:player) { Player.new }
      it {
        expect(player.do('exit', nil)).to eq [false, nil]
      }
    end

    context 'key = \'right\', enemies = nil' do
      let(:player) { Player.new }
      it {
        expect(player.do('right', nil)).to eq [true, nil]
      }
    end

    context 'key = \'left\', enemies = nil' do
      let(:player) { Player.new }
      it {
        expect(player.do('left', nil)).to eq [true, nil]
      }
    end

    context 'key = \'up\', enemies = nil' do
      let(:player) { Player.new }
      it {
        expect(player.do('up', nil)).to eq [false, nil]
      }
    end

    context 'key = \'down\', enemies = nil' do
      let(:player) { Player.new }
      it {
        expect(player.do('down', nil)).to eq [false, nil]
      }
    end

    context 'key = \'p\', enemies = nil' do
      let(:player) { Player.new }
      it {
        expect(player.do('p', nil)).to eq [false, nil]
      }
    end

    context 'key = \'0\', enemies = Array of Enemy' do
      let(:player) { Player.new }
      it {
        enemy1 = Enemy.new(10)
        enemy1.position = Vector[10, 0, 0]
        enemies_input = [enemy1]

        enemy1.color = Vector[0.96, 0, 0.4, 0.5]
        enemies_expected = [enemy1]
        expect(player.do('0', enemies_input)).to eq [false, enemies_expected]
      }
    end
  end
end
