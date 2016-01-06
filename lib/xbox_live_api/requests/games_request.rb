require 'xbox_live_api/requests/base_request'
require 'xbox_live_api/requests/http_session_gateway'
require 'oj'

class XboxLiveApi
  module Requests
    class GamesRequest < BaseRequest

      def get_game_list_json(user_id, version)
        url = "https://achievements.xboxlive.com/users/xuid(#{user_id})/history/titles?maxItems=1000&orderBy=unlockTime"
        resp = HttpSessionGateway.new.get(url, header: header_for_version(version)).body
        json = Oj.load(resp)
        json['titles']
      end


      def get_game_json(title_id, user_id, version)
        url = "https://achievements.xboxlive.com/users/xuid(#{user_id})/history/titles?titleId=#{title_id}"
        resp = HttpSessionGateway.new.get(url, header: header_for_version(version)).body
        json = Oj.load(resp)
        json['titles']
      end

    end
  end
end
