require 'json'

module JPush
  class ReceivedsResult
    attr_accessor  :isok, :list
    def initialize
      @isok = false
    end

    def fromResponse(wrapper)
      logger = Logger.new(STDOUT)
      if wrapper.code != 200
        logger.error('Error response from JPush server. Should review and fix it. ')
        logger.info('HTTP Status:' + wrapper.code.to_s)
        logger.info('Error Message' + wrapper.error.to_s)
        raise JPush::ApiConnectionException.new(wrapper)
      end
      content = wrapper.getResponseContent
      logger.info('ResponseContent: ' + content)
      hash = JSON.parse(content)
      i = 0
      @list = []
      while i < hash.length
        re = JPush::Receiveds.new
        re.msg_id = hash[i]['msg_id']
        re.ios_apns_sent = hash[i]['ios_apns_sent']
        re.ios_apns_received = hash[i]['ios_apns_received']
        re.android_received = hash[i]['android_received']
        list.push re
        i = i+1
      end
      @isok = true
      return self
    end

    def toJSON
      array = []
      i = 0
      while i < @list.length
        array.push @list[i].toJSON
        i = i + 1
      end
      return array.to_json
    end

  end

  class Receiveds
    attr_accessor :msg_id, :android_received, :ios_apns_sent, :ios_apns_received
    def initialize
      @msg_id = nil
      @android_received = nil
      @ios_apns_sent = nil
      @ios_apns_received = nil
    end

    def toJSON
      array = {}
      array['msg_id'] = @msg_id
      array['android_received'] = @android_received
      array['ios_apns_sent'] = @ios_apns_sent
      array['ios_apns_received'] = @ios_apns_received
      return array
    end
  end
end
