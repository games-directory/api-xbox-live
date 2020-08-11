require 'xbox_live_api/requests/games_request'

class XboxLiveApi
  module Requests
    class XboxOneGamesRequest < GamesRequest

      def for(user_id)
        return get_game_list_json(user_id, Version::XBOX_ONE)
        games.collect do |game|
          Game.new(name: game['name'],
                   id: game['titleId'],
                   last_unlock_time: game['lastUnlock'],
                   platform: Game::Platform::XBOX_ONE,
                   current_achievements: game['earnedAchievements'],
                   current_gamerscore: game['currentGamerscore'],
                   total_gamerscore: game['maxGamerscore'])
        end
      end
    end
  end
end