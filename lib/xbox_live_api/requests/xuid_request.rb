require 'xbox_live_api/requests/base_request'
require 'oj'
require 'open-uri'

class XboxLiveApi
  module Requests
    class XuidRequest < BaseRequest

      def for(gamer_tag)
        resp = make_request(gamer_tag)
        handle_response(resp, gamer_tag)
      end

      private

      def make_request(gamer_tag)
        url = "https://profile.xboxlive.com/users/gt(#{URI::encode(gamer_tag)})/profile/settings"

        HttpSessionGateway.new.get(url, header: header_for_version(Version::XBOX_ONE), body: nil).body
      end

      def handle_response(resp, user_id)
        json = Oj.load(resp)
        if users = json['profileUsers']
        	users.first['id']
        end
      end

    end
  end
end
