require 'rails_helper'

describe User do
  describe 'after_create' do
    it 'should create a battle pass for the user' do
      u = create(:user)
      expect(u.battle_passes.count).to eq 1
    end
  end
end
