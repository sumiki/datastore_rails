require "rails_helper"

RSpec.describe User, :type => :model do

  def clear_datastore
    User.all.each do |user|
      user.destroy
    end
  end

  describe 'save' do
    before do
      clear_datastore
    end

    it 'should create' do
      user = User.new
      user.email = 'sumikio@gmail.com'
      user.password = 'P@ssw0rd'
      user.save

      expect(User.all.length).to eq(1)
      expect(user.password).to be_blank
    end
  end

  describe 'User.authenticate' do
    let!(:user) { create(:user) }

    it 'success' do
      login_result = User.authenticate('sumikio@gmail.com', 'P@ssw0rd')
      expect(login_result).to be_truthy
    end

    it 'fails' do
      login_result = User.authenticate('sumikio@gmail.com', 'P@ssw0rd1')
      expect(login_result).to be_falsy
    end
  end

end

