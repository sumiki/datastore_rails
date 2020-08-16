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

  def sample_first_sell(user, account)
    Holding.sell(
      user_id: user.id,
      account_id: account.id,
      ticker_symbol: 'SPY',
      purchase_price: 10.01,
      purchase_date: '2020/07/20',
      selling_count: 2,
      selling_price: 13.01,
      selling_date: '2020/08/01'
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
      aggregate_detail = holding.aggregate_details[0]
      expect(aggregate_detail['purchase_date']).to eq('2020/07/20')
      expect(aggregate_detail['count']).to eq(3)
      expect(aggregate_detail['purchase_price']).to eq(10.01)
      expect(aggregate_detail['purchase_price_total']).to eq(30.03)
    end

    it 'should set aggregate_details second' do
      holding = sample_first_purchase(user, account)
      holding = sample_second_purchase(user, account)
      holding.set_aggregate_details
      expect(holding.aggregate_details.length).to eq(2)
    end

    it 'should set aggregate_details sold some' do
      holding = sample_first_purchase(user, account)
      sample_first_sell(user, account)
      sleep 0.5
      holding.set_aggregate_details
      sleep 0.5
      expect(holding.aggregate_details.length).to eq(2)
      sold = holding.aggregate_details.detect{|item| item['sold_price'].present? }
      holding = holding.aggregate_details.detect{|item| item['sold_price'].blank? }

      expect(sold['sold_price']).to eq(13.01)
      expect(sold['sold_date']).to eq('2020/08/01')
      expect(holding['sold_price']).to eq(nil)
      expect(holding['sold_date']).to eq(nil)
    end
  end

end
