class Holding < DatastoreBase

  attr_accessor :user_id,
                :account_id,
                :ticker_symbol,
                :name,
                :details

    def entity_properties
      %w[user_id account_id ticker_symbol name details]
    end

  def self.tidy_list(holdings)
    hash = {}
    holdings.each do |holding|
      hash[holding.ticker_symbol] ||= {}
      hash[holding.ticker_symbol][:ticker_symbol] ||= holding.ticker_symbol
      hash[holding.ticker_symbol][:name] ||= holding.name
      hash[holding.ticker_symbol][:count] ||= 0
      hash[holding.ticker_symbol][:count] += 1
    end
    hash.keys.map{|key| hash[key] }
  end


end
