require 'xbox_live_api/requests/base_request'
require 'xbox_live_api/requests/http_session_gateway'
require 'xbox_live_api/json_parsers'
require 'json'

class XboxLiveApi
  module Requests
    class XboxOneAchievementRequest < BaseRequest

      def for(user_id, game)
        url = "https://achievements.xboxlive.com/users/xuid(#{user_id})/achievements?titleId=#{game}&maxItems=250"
        json = HttpSessionGateway.new.get(url, header: header_for_version(4)).body
        # json = HttpSessionGateway.new.get(url, header: header_for_version(Version::XBOX_ONE)).body
        return JSON.parse(json)
        # JsonParsers::XboxOneAchievementJsonParser.new.parse_achievements_from(json)
      end
    end
  end
end