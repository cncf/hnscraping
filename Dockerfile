FROM ruby:2.7.1

WORKDIR /repo

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "lib/generate_files.rb"]
