path =  File.expand_path('../', __FILE__)
require File.join(path, 'http_client.rb')
require File.join(path, 'push_client.rb')
require 'json'

module JPush
  class ReportClient
    @@REPORT_HOST_NAME = 'https://report.jpush.cn'
    @@REPORT_RECEIVE_PATH = '/v3/received/detail'
    @@REPORT_USER_PATH = '/v3/users'
    @@REPORT_MESSAGE_PATH = '/v3/messages/detail'
    def initialize(maxRetryTimes)
      @httpclient=JPush::NativeHttpClient.new(maxRetryTimes)
    end


    def getReceiveds(msg_ids)
      msg_ids = checkMsgids(msg_ids)
      @url = @@REPORT_HOST_NAME + @@REPORT_RECEIVE_PATH + '?msg_ids=' + msg_ids
      result = JPush::ReceivedsResult.new
      wrapper = @httpclient.sendGet(@url, nil)
      return result.fromResponse(wrapper)
    end

    def getMessages(msg_ids)
      msg_ids = checkMsgids(msg_ids)
      @url = @@REPORT_HOST_NAME + @@REPORT_MESSAGE_PATH + '?msg_ids=' + msg_ids
      result = JPush::GetMessagesResult.new
      wrapper = @httpclient.sendGet(@url, nil)
      return result.fromResponse(wrapper)
    end

    def getUsers(timeUnit, start, duration)
      @url = @@REPORT_HOST_NAME + @@REPORT_USER_PATH + '?time_unit=' + timeUnit + '&start=' + start + '&duration=' + duration.to_s
      result = JPush::UserResult.new
      puts @url
      wrapper = @httpclient.sendGet(@url, nil)
      return result.fromResponse(wrapper)
    end

    def checkMsgids(msg_ids)
      if msg_ids.empty?
        raise ArgumentError.new('msgIds param is required')
      end
      msg_ids = msg_ids.split.join('').to_s
      return msg_ids
    end

  end
end
