require "rails_helper"

RSpec.describe User, :type => :model do
  let!(:user) { create(:user) }
  let!(:account) { create(:account, user_id: user.id) }

  before do
    clear_datastore
  end

  def sample_first_purchase(user, account)
    Holding.purchase(
      user_id: user.id,
      account_id: account.id,
      ticker_symbol: 'SPY',
      name: 'SP500',
      purchase_price: 10.01,
      purchase_count: 3,
      purchase_date: '2020/07/20'
    )
  end

  def sample_second_purchase(user, account)
    Holding.purchase(
      user_id: user.id,
      account_id: account.id,
      ticker_symbol: 'SPY',
      name: 'SP500',
      purchase_price: 12.01,
      purchase_count: 3,
      purchase_date: '2020/07/22'
    )
  end


  describe 'purchase' do

    describe 'create new holding' do
      it 'should create' do
        holding = sample_first_purchase(user, account)
        expect(Holding.all.length).to eq(1)
        expect(holding.class).to eq(Holding)
        expect(holding.details.length).to eq(3)
      end
    end

    describe 'purchase more holding' do
      it 'should not create holding but holding details' do
        holding = sample_first_purchase(user, account)
        sleep 1
        holding = sample_second_purchase(user, account)
        expect(Holding.all.length).to eq(1)
        expect(holding.class).to eq(Holding)
        expect(holding.details.length).to eq(6)
      end
    end
  end

  describe 'set_aggregate_details' do
    it 'should set aggregate_details' do
      holding = sample_first_purchase(user, account)
      holding.set_aggregate_details
      expect(holding.aggregate_details.length).to eq(1)
    end
  end

end
