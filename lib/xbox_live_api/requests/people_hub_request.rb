require 'xbox_live_api/requests/base_request'
require 'httparty'

class XboxLiveApi
  module Requests
    class PeopleHubRequest < BaseRequest
      include HTTParty
      
      base_uri 'https://peoplehub.xboxlive.com/users/me/people'
      
      FIELDS ||= ['detail', 'preferredColor', 'presenceDetail', 'multiplayerSummary'].freeze

      # @public
      def me(xuid)
        self.class.get("/xuids(#{ xuid })/decoration/#{ FIELDS.join(',') }",
          headers: {
            'Authorization' => @auth_header,
            'Accept-Language' => 'en-GB',
            'x-xbl-contract-version' => '4'
          }
        )
      end

      # Only works for logged in users, using the Authorization value
      # @private
      #
      # Gets all gamer's friends. This returns the same response as @me but doesn't require the caller to know the xuids.
      # This should be used first to gather all the xuids and then use @me(xuid, xuid) to gather presence information for specific gamers.
      #
      def friends
        self.class.get("/social/decoration/#{ FIELDS.join(',') }",
          headers: {
            'Authorization' => @auth_header,
            'Accept-Language' => 'en-GB',
            'x-xbl-contract-version' => '4'
          }
        )
      end
    end
  end
end
