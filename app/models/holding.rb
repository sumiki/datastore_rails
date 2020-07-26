class Holding < DatastoreBase

  attr_accessor :user_id,
                :account_id,
                :ticker_symbol,
                :name,
                :purchase_price,
                :purchase_date,
                :sold_price,
                :sold_date

  def entity_properties
    %w[user_id account_id ticker_symbol name purchase_price purchase_date sold_price sold_date]
  end

end
