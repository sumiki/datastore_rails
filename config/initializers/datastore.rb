if Rails.env.production?
  # Localのテストの場合は
  json_path = Rails.root.join('tf', '.terraform', 'norcal-282302-5d3c6d50ddbb.json')
  if File.exist?(json_path)
    file = File.open json_path
    data = JSON.load file

    ENV['GCLOUD_PROJECT'] = data['project_id']
    ENV['SERVICE_ACCOUNT_PRIVATE_KEY'] = data['private_key']
    ENV['SERVICE_ACCOUNT_CLIENT_EMAIL'] = data['client_email']
  end
else
  ENV['DATASTORE_EMULATOR_HOST'] = 'localhost:8081'

  # Local Emuratorの指定
  # ENV['DATASTORE_PROJECT_ID'] = data['project_id']

  Process.spawn('gcloud beta emulators datastore start')
end


