require 'xbox_live_api/requests/base_request'
require 'httparty'

class XboxLiveApi
  module Requests
    class PeopleHubRequest < BaseRequest
      include HTTParty
      
      base_uri 'https://peoplehub.xboxlive.com/'

      # contract-version = 4

      # @private
      def friends(xuid)
        self.get('users/me/people/social/decoration/detail,preferredColor,presenceDetail,multiplayerSummary')
      end

      def me
        self.get('users/me/people/xuids(2533274897800701)/decoration/detail,preferredColor,presenceDetail')
      end
    end
  end
end
