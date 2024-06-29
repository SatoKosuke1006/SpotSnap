require 'dotenv'
require 'net/smtp'

# .envファイルを読み込む
Dotenv.load

smtp_username = ENV['SMTP_USERNAME']
smtp_password = ENV['SMTP_PASSWORD']

begin
  Net::SMTP.start('email-smtp.us-east-1.amazonaws.com', 587, 'localhost', smtp_username, smtp_password, :login) do |smtp|
    puts 'SMTP認証に成功しました。'
  end
rescue => e
  puts "SMTP認証に失敗しました: #{e.message}"
end