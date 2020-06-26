FROM ruby:2.7.1

WORKDIR /repo

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["puma", "-C", "config/puma.rb"]
