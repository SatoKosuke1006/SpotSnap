# ベースイメージを指定
FROM --platform=linux/amd64 ruby:3.3.0

# 作業ディレクトリを指定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

# Gemをインストール
RUN bundle install && chmod +x /usr/local/bundle/bin/rails

ENV RAILS_MASTER_KEY=59dd1bc71f113b37e90baa87e83b4f45ca271e99ddf3afb7f4e6708619407461173b22f349b77efec0fa90f7fb1e5b9ffeb52abd984c24749175f5ca9435868a

# ソースコードをコピー
COPY . .

# ポートの公開
EXPOSE 80

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]