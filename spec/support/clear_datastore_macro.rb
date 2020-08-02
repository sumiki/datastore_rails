module ClearDatastoreMacro
  def clear_datastore
    models = [
      User,
      Account,
      Holding,
      HoldingDetail
    ]

    models.each do |model|
      model.all.each do |m|
        m.destroy
      end
    end
  end
end
