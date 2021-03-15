require 'kernel'
require 'xbox_live_api/requests'

class XboxLiveApi
  attr_reader :session_info

  def session_expired?
    @session_info.expired?
  end

  def initialize(token = nil, user_id = nil)
    @session_info = OpenStruct.new(
      token: token,
      user_id: user_id
    )
  end

  # NEW
  
  # => XboxLiveApi.new(token, user_id).titles
  def titles(xuid, offset: 0, limit: 1000)
    Requests::TitleHubRequest.new(@session_info.token).titles(xuid, offset, limit)
  end

  # => XboxLiveApi.new(token, user_id).people.me(xuid)
  # => XboxLiveApi.new(token, user_id).people.friends()
  #
  def people(xuid, offset: 0, limit: 1000)
    Requests::PeopleHubRequest.new(@session_info.token)
  end

  # => XboxLiveApi.new(token, user_id).videos
  #
  def videos(xuid, offset: nil, limit: 1000)
    Requests::GameClipsMetadataRequest.new(@session_info.token)
  end

  # => XboxLiveApi.new(token, user_id).videos
  #
  def screenshots(xuid, offset: nil, limit: 1000)
    Requests::ScreenshotsMetadataRequest.new(@session_info.token)
  end
  
  # NEW

  # DEPRECATE
  # @param user_id [String] user_id to get profile for, defaults to session_info user_id
  # @return [XboxLiveApi::Profile] profile information for the given user

  def get_profile(user_ids = [])
    user_ids = (user_ids.empty? ? (user_ids << @session_info.user_id) : user_ids)
    Requests::ProfileRequest.new(@session_info.token).for(user_ids)
  end

  def get_presence(user_id = nil)
    user_id ||= @session_info.user_id
    Requests::PresenceRequest.new(@session_info.token).for(user_id)
  end

  # @return [Array<XboxLiveApi::Profile>] all friends' profiles for the current user
  def get_friend_ids(user_id = nil)
    user_id ||= @session_info.user_id
    Requests::FriendRequest.new(@session_info.token).for(user_id)
  end

  def get_game_details(ids = [], platform = '', user_id = nil)
    user_id ||= @session_info.user_id
    Requests::GameDetailsRequest.new(@session_info.token).for(user_id, ids, platform, :canonical)
  end

  def get_game_details_from_hex(ids = [], platform = '', user_id = nil)
    user_id ||= @session_info.user_id
    Requests::GameDetailsRequest.new(@session_info.token).for(user_id, ids, platform, :hex)
  end

  def get_game_details_from_search(query, user_id = nil)
    user_id ||= @session_info.user_id
    Requests::GameSearchRequest.new(@session_info.token).for(user_id, query)
  end

  # @param user_id [String] user_id to get games for, defaults to session_info user_id
  # @return [Array<XboxLiveApi::Game>] list of Xbox one games played by the given user
  def get_xbox_one_games(user_id = nil)
    user_id ||= @session_info.user_id
    Requests::XboxOneGamesRequest.new(@session_info.token).for(user_id)
  end

  # @param user_id [String] user_id to get games for, defaults to session_info user_id
  # @return [Array<XboxLiveApi::Game>] list of Xbox 360 games played by the given user
  def get_xbox_360_games(user_id = nil)
    user_id ||= @session_info.user_id
    Requests::Xbox360GamesRequest.new(@session_info.token).for(user_id)
  end

  # @param game [XboxLiveApi::Game] game to get achievements for
  # @return [Array<XboxLiveApi::Achievement>] list of Xbox achievements for the current user and the given game
  def get_achievements_for(user, game, platform)
    Requests::AchievementRequest.new(@session_info.token).for(user, game, platform)
  end

  # @param gamertag [String] gamertag to get xuid for
  # @return xuid for the given gamertag
  def get_xuid(gamertag)
    Requests::XuidRequest.new(@session_info.token).for(gamertag)
  end

  # @param title_id [String] xbox live title id for game title
  # @param user_id [String] user_id to get title history for, defaults to session_info user_id
  # @return [XboxLiveApi::Game] given users stats for given title
  def get_title_history(title_id, user_id = nil)
    user_id ||= @session_info.user_id
    Requests::Xbox360GamesRequest.new(@session_info.token).for_title(title_id, user_id)
  end
end