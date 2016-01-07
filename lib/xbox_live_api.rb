require 'kernel'
require 'xbox_live_api/requests'

class XboxLiveApi

  # @return [XboxLiveApi::SessionInfo]
  attr_reader :session_info

  # Creates a new XboxLiveApi instance by logging in a user
  # @param email [String] Windows Live account email to use to login
  # @param password [String] associated password to use to login
  # @return [XboxLiveApi]
  # @example
  #   api = XboxLiveApi.login('example@example.com', 'password123')
  # @note Emails and passwords are not stored, logged, or otherwise used in any
  #   manner other than to securely login to Xbox Live
  def self.login(email, password)
    session_info = Requests::Login.new(email, password).execute
    XboxLiveApi.new(session_info)
  end

  # Creates a new XboxLiveApi instance with session info from a prior instance
  # @param session_info [XboxLiveApi::SessionInfo] session info from a prior XboxLiveApi instance
  # @return [XboxLiveApi]
  # @example
  #   api = XboxLiveApi.login('example@example.com', 'password123')
  #   api2 = XboxLiveApi.with_session_info(api.session_info)
  def self.with_session_info(session_info)
    XboxLiveApi.new(session_info)
  end

  # @param user_id [String] user_id to get profile for, defaults to session_info user_id
  # @return [XboxLiveApi::Profile] profile information for the given user
  def get_profile(user_id = nil)
    user_id ||= @session_info.user_id
    Requests::ProfileRequest.new(@session_info.token).for(user_id)
  end

  # @return [Array<XboxLiveApi::Profile>] all friends' profiles for the current user
  def get_friend_ids
    Requests::FriendRequest.new(@session_info.token).for(@session_info.user_id)
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
  def get_achievements_for(game)
    Requests::AchievementRequest.new(@session_info.token).for(@session_info.user_id, game)
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

  private

  def initialize(session_info)
    @session_info = session_info
  end
end
