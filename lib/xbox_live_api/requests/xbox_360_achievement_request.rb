require 'xbox_live_api/requests/base_request'
require 'xbox_live_api/requests/http_session_gateway'
require 'xbox_live_api/json_parsers'
require 'json'

class XboxLiveApi
  module Requests
    class Xbox360AchievementRequest < BaseRequest

      def for(user_id, game)
        @parser = JsonParsers::Xbox360AchievementJsonParser.new
        unlocked_achievements = get_unlocked_achievements(game, user_id)
        all_achievements = get_all_achievements(game, user_id)
        combine_achievements(all_achievements, unlocked_achievements)
      end

      private

      def get_unlocked_achievements(game, user_id)
        url = "https://achievements.xboxlive.com/users/xuid(#{user_id})/achievements?titleId=#{game}&maxItems=250"
        get_achievements(url)
      end

      def get_all_achievements(game, user_id)
        url = "https://achievements.xboxlive.com/users/xuid(#{user_id})/titleachievements?titleId=#{game}&maxItems=250"
        get_achievements(url)
      end

      def get_achievements(url)
        json = HttpSessionGateway.new.get(url, header: header_for_version(3)).body
        # json = HttpSessionGateway.new.get(url, header: header_for_version(Version::XBOX_360)).body
        return JSON.parse(json)
        # @parser.parse_achievements_from(json)
      end

      def combine_achievements(all_achievements, unlocked_achievements)
        unlocked_ids = unlocked_achievements['achievements'].collect { |a| a['id'] }
        all_achievements['achievements'].reject! { |achievement| unlocked_ids.include?(achievement['id']) }
        unlocked_achievements.merge(all_achievements)
      end
    end
  end
end