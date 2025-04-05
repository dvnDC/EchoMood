FROM ruby:3.4.2

# Instalacja zależności systemowych
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Ustawienie katalogu roboczego
WORKDIR /app

# Skopiowanie plików aplikacji
COPY Gemfile Gemfile.lock ./

# Instalacja gemów
RUN gem install bundler && bundle install

# Skopiowanie pozostałych plików aplikacji
COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
