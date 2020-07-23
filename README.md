# Deploying on Cloud Run
GOOGLE_CLOUD_PROJECT=norcal-282302

RAILS_ENV=production bundle exec rails assets:precompile

docker build -t datastore_rails:0.0.1 .

docker run -d -it -p  3000:3000 datastore_rails:0.0.1

docker tag datastore_rails:0.0.1 us.gcr.io/${GOOGLE_CLOUD_PROJECT}/datastore_rails:0.0.1

docker push us.gcr.io/${GOOGLE_CLOUD_PROJECT}/datastore_rails:0.0.1

gcloud run deploy --image=us.gcr.io/${GOOGLE_CLOUD_PROJECT}/datastore_rails:0.0.1 --platform managed --concurrency 1

terraform apply -var-file=prod.tfvars
