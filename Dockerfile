# ベースイメージを指定
FROM ruby:3.3.0

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libxml2-dev libxslt1-dev

# 作業ディレクトリを指定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

# Gemをインストール
RUN bundle install --jobs=4 && chmod +x /usr/local/bundle/bin/rails

# ソースコードをコピー
COPY . .

# ポートの公開
EXPOSE 3000

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]