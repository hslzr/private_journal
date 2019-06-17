FROM ruby:2.5.3-slim
LABEL maintainer "Salazar <salazar@hslzr.com>"

# Set Timezone
ENV TZ=America/Monterrey
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -qqq && apt-get install -y -qqq --no-install-recommends \
    build-essential \
    curl \
    gnupg1 gnupg2 \
    libpq-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Remove default NodeJS package
RUN apt-get -y -qqq remove nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y --no-install-recommends \
        nodejs \
        && npm install -g yarn

# Creates and switches to workdir
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Cache-copy Gemfile
COPY Gemfile .
COPY Gemfile.lock .
# Install gems
RUN gem install bundler
RUN bundle install -j10

COPY . .
