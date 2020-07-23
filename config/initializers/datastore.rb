unless Rails.env.production?
  file = File.open Rails.root.join('tf', '.terraform', 'norcal-282302-5d3c6d50ddbb.json')
  data = JSON.load file

  ENV['GCLOUD_PROJECT'] = data['project_id']
  ENV['SERVICE_ACCOUNT_PRIVATE_KEY'] = data['private_key']
  ENV['SERVICE_ACCOUNT_CLIENT_EMAIL'] = data['client_email']
  ENV['DATASTORE_EMULATOR_HOST'] = 'localhost:8081'
  ENV['DATASTORE_PROJECT_ID'] = data['project_id']

  #pid = Process.spawn('gcloud beta emulators datastore start')
end


