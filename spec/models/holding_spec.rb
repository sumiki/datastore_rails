require "rails_helper"

RSpec.describe User, :type => :model do
  before do
    clear_datastore
  end

  describe 'purchase' do
    let!(:user) { create(:user) }
    let!(:account) { create(:account, user_id: user.id) }

    describe 'create new holding' do
      it 'should create' do
        holding = Holding.purchase(
          user_id: user.id,
          account_id: account.id,
          ticker_symbol: 'SPY',
          name: 'SP500',
          purchase_price: 10.01,
          purchase_count: 3
        )

        expect(Holding.all.length).to eq(1)
        expect(holding.class).to eq(Holding)
        expect(holding.details.length).to eq(3)
      end
    end
  end

end
