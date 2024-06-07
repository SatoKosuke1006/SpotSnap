# ベースイメージを指定
FROM --platform=linux/amd64 ruby:3.3.0

# 作業ディレクトリを指定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

# Gemをインストール
RUN bundle install && chmod +x /usr/local/bundle/bin/rails

# ソースコードをコピー
COPY . .

# ポートの公開
EXPOSE 80

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]