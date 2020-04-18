class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      File.open('flag.txt',"r") do |file|
        file.each_line do |mode|
      File.open('flag.txt',"w") do |file|

      if mode.include?("0")
        if event.message['text'].include?("change")
            response = "changed"
            file.puts("1")
        elseif event.message['text'].include?("a")
          response = "あいうえお"
          file.puts("0")
        else
          response = "ok"
          file.puts("0")
        end
      end

      if mode.include?("1")
        if event.message['text'].include?("change")
            response = "changed"
            file.puts("0")
        elseif event.message['text'].include?("a")
          response = "かきくけこ"
          file.puts("1")
        else
          response = "ok"
          file.puts("1")
        end
      end

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end
end
