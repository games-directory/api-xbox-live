require 'xbox_live_api/requests/base_request'
require 'httparty'

class XboxLiveApi
  module Requests
    class PeopleHubRequest < BaseRequest
      include HTTParty
      
      base_uri 'https://peoplehub.xboxlive.com/users'
      
      FIELDS ||= ['detail', 'preferredColor', 'presenceDetail', 'multiplayerSummary'].freeze

      # batch_details, presences, friends and recommendations return the same data format
      # 

      # @public
      # https://peoplehub.xboxlive.com/users/me/people/batch/decoration/detail,preferredColor,presenceDetail,multiplayerSummary
      def batch_details(xuids = [])
        raise 'Too many XUIDS to check, max limit is 500' if xuids.length >= 501
        raise 'XUIDS must be an array of xuids' unless xuids.is_a?(Array)
        raise 'At least one XUID is required' if xuids.length == 0
        
        self.class.post("/me/people/batch/decoration/#{ FIELDS.join(',') }",
          headers: {
            'Authorization' => @auth_header,
            'Accept-Language' => 'en-GB',
            'Content-Type' => 'application/json',
            'x-xbl-contract-version' => '4'
          },
          body: {
            'xuids': xuids
          }.to_json
        )
      end

      # @public
      # https://peoplehub.xboxlive.com/users/me/people/xuids(2533274897800701,2533274891225914)/decoration/detail,preferredColor,presenceDetail
      def details(xuids = [])
        warn 'You should use @batch_details instead, the limit is hight, 500, and it gives the same data'

        raise 'Too many XUIDS to check, max limit is 10' if xuids.length >= 11
        raise 'At least one XUID is required' if xuids.length == 0

        self.class.get("/me/people/xuids(#{ xuid.join(',') })/decoration/#{ FIELDS.join(',') }",
          headers: {
            'Authorization' => @auth_header,
            'Accept-Language' => 'en-GB',
            'x-xbl-contract-version' => '4'
          }
        )
      end

      # Gets all gamer's friends. This returns the same response as @me but doesn't require the caller to know the xuids.
      # This should be used first to gather all the xuids and then use @me(xuid, xuid) to gather presence information for specific gamers.
      #
      # @public
      # https://peoplehub.xboxlive.com/users/xuid(2533274902250349)/people/social/decoration/detail,preferredColor,presenceDetail,multiplayerSummary
      # https://peoplehub.xboxlive.com/users/me/people/social/decoration/detail,preferredColor,presenceDetail,multiplayerSummary
      def friends(xuid = nil)
        self.class.get("/#{ xuid ? "xuid(#{ xuid })" : 'me' }/people/social/decoration/#{ FIELDS.join(',') }",
          headers: {
            'Authorization' => @auth_header,
            'Accept-Language' => 'en-GB',
            'x-xbl-contract-version' => '4'
          }
        )
      end

      # Gets all gamer's friend recommendations. This data is provided by XBOX
      #
      # @private
      # https://peoplehub.xboxlive.com/users/me/people/recommendations/decoration/detail,preferredColor,presenceDetail,multiplayerSummary
      def recommendations
        self.class.get("/me/people/recommendations/#{ FIELDS.join(',') }",
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
