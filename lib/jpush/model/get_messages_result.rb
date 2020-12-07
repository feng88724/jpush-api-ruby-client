require 'json'

module JPush
  class GetMessagesResult
    attr_accessor  :isok, :result
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
      @result = JSON.parse(content)
      return self
    end

    def toJSON
      return @result.to_json
    end

  end


end
