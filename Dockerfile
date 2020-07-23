FROM ruby:2.7
WORKDIR /app
COPY Gemfile Gemfile.lock ./
ENV RAILS_ENV production
RUN bundle install
COPY . .
EXPOSE 3000
ENV RAILS_SERVE_STATIC_FILES true
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

