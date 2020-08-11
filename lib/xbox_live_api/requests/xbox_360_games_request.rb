require 'xbox_live_api/requests/games_request'

class XboxLiveApi
  module Requests
    class Xbox360GamesRequest < GamesRequest

      def for(user_id)
        return get_game_list_json(user_id, Version::XBOX_360)
        # TODO create a parser
        games.collect do |game|
          Game.new(name: game['name'],
                   id: game['titleId'],
                   last_unlock_time: game['lastPlayed'],
                   platform: Game::Platform::XBOX_360,
                   current_achievements: game['currentAchievements'],
                   current_gamerscore: game['currentGamerscore'],
                   total_gamerscore: game['totalGamerscore'])
        end
      end

      def for_title(title_id, user_id)
        return get_game_json(title_id, user_id, Version::XBOX_360)
        # TODO create a parser
        games = json.collect do |game|
          Game.new(name: game['name'],
                   id: game['titleId'],
                   last_unlock_time: game['lastPlayed'],
                   platform: Game::Platform::XBOX_360,
                   current_achievements: game['currentAchievements'],
                   current_gamerscore: game['currentGamerscore'],
                   total_gamerscore: game['totalGamerscore'])
        end
        games.first
      end

    end
  end
end
