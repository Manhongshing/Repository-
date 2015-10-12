require 'rails_helper'

RSpec.describe User do
  describe '#unique?' do
    before(:each) do
      create(:user)
    end

    context 'unique' do
      it 'should return true' do
        u = User.new(name: 'testRspecUni',
                     password: 'a',
                     password_confirmation: 'a')
        expect(u.unique?).to be_truthy
      end
    end

    context 'not unique' do
      it 'should return false' do
        u = User.new(name: 'testRspec',
                     password: 'a',
                     password_confirmation: 'a')
        expect(u.unique?).to be_falsey
      end
    end
  end
end
