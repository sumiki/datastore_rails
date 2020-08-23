
class HoldingAggregateDetailsJob < ApplicationJob

  WAIT = 0.5

  # HoldingAggregateDetailsJob.set(wait: 1.second).perform_later(holding_id: holding.id)
  def perform(holding_id:)
    holding = Holding.find(holding_id)
    holding.set_aggregate_details
  end
end
