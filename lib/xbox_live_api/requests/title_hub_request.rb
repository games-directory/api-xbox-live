require 'xbox_live_api/requests/base_request'
require 'httparty'

class XboxLiveApi
  module Requests
    class TitleHubRequest < BaseRequest
      include HTTParty

      base_uri 'https://titlehub.xboxlive.com/users'

      # @public
      def titles(xuid, offset, limit)
        self.class.post("/xuid(#{ xuid })/titles/titlehistory/decoration/scid,achievement,stats,gamepass,image,detail,friendswhoplayed,alternateTitleId",
          headers: {
            'Authorization' => @auth_header,
            'Accept-Language' => 'en-GB',
            'x-xbl-contract-version' => '2'
          },

          query: {
            maxItems: limit
          }
        )
      end

    private
      
      def post(url, query = {})
        self.class.post(url,
          headers: {
            'Authorization' => @auth_header,
            'Accept-Language' => 'en-GB',
            'x-xbl-contract-version' => '2'
          },
          **query
        )
      end
    end
  end
end
