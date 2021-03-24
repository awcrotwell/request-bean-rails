# frozen_string_literal: true

class RequestChannel < ApplicationCable::Channel
  def subscribed
    stream_from "request_channel_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
