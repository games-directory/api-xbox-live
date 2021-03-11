require 'kernel'
require 'xbox_live_api/requests'

class XboxLiveApi
  attr_reader :session_info

  def session_expired?
    @session_info.expired?
  end

  def initialize(token = nil, user_id = nil)
    @session_info = OpenStruct.new(
      token: token || 'XBL3.0 x=17707809191848599152;eyJlbmMiOiJBMTI4Q0JDK0hTMjU2IiwiYWxnIjoiUlNBLU9BRVAiLCJjdHkiOiJKV1QiLCJ6aXAiOiJERUYiLCJ4NXQiOiIxZlVBejExYmtpWklFaE5KSVZnSDFTdTVzX2cifQ.FRef41A8FxMMOuPsJoT5ENNQBbXyJIO5nOH9QykgnE5xvYENc9pabryFdHIzqUMPJZlwMYrqcarrpTSojpqSbTTIlLl74zviRFklFAFIrW8v-R_KW0kbpyVeR5suUqdPW_r0pZRyrD-zE5Kk4JbuOCI8tcUG_MGi6KHSJ7TpiyA.b30D_jNr_8wyg9GoLx3Nkg.YKKEEBBvu9pKDVpd0eV_iBAEi-BMUJvUsI7opGl3Ft2we-0Kkg0vtFc8veAM7uhy1OC-g64C1j2FOI50sy-Qwkpmu1g0El7TANgeu8ElGdiTVdzDDpB8PdzKZgZqHO5NUGwNP-8-KQ9x4yVFi2z_80f-imA2mvNsI0Npc4aR3waEYbqQz3l9UDfs9QfF3TBPs8prFY2vANXFxmx08RmJvkiazmRuU9wTtmswsRKQFQSywDQpeoPBeSgw5cqVfNFIh7hUO9q_i3gGHT6yY71_3QtehSvTq8y-EJUlZ4zsnfTsea8WNC5yld11LcpPI5brVZ_00GdtnLgcUCDFPWgWbQkZCmYr7Rt_iYOlCqnhZxo0TZjQ-e0_KzeY84jokrPVTVyWxNhyilWPEtRkJZBuzQWzvxo0Sylz8QjtRnuKsldUk_rpB1-82fF8ZQEyFdG7P2KSHMwqysQhkP7ECsDrT960bq80jpx38v76D1faYTKtH4uQDfq2fPICsg37SE5RFW2xvDMzCLfq2oNCzodzwz1VIungHMH86oPgodlBBVzjVVN-hecSx0qlkmW26RqhVakelRpnHuDJP0patjRlKa3ohH10p4oLyqDWCkKc2t2Dg-v8zIJ1J9PK1KpB87PARbCh7WrG25LOrKtoWSLj_vuLssBccCp_Re1i_YTihiEeFtdE1XPVB6_VmgIhP03Z7srRO3rnSpGdpD1pxdyfeh9N9vdYPvygt3b1cXswJ3cZeYhNHScgTVJZeTM2JNgso5fj1dqUkn8yDVkHCpJWW0zPkuVzy5mQ7X63Dc5Uqinx6Xvmh7QbvIBzvLroMMq6Abpepj2GCi2-AwicrjM4saJVnYXABEChJfXIT1uOGkrAP1NvptgQ2e4BI3-y5NM4bQL_CiFa5u6g7tYRm-7-V0nyVoFkL9aWXaTqFnfSNqG1KAgjuijEgOV33lQ7PN1v4lhXLD7uRGF7CTkw598iaSvbUB77V4lM16npfDN7j8fkhM7O_uX-ApXspDw1A76g_gul6-znfQjoBLVAH6oHo3JV6Mh_P8Llul6zGWhyJGxY8gSH9MeB2AXakyemVkFV96NKsadyAnhSzwE0O8fqvYbOpOLlfdLnfDMenncRBn3GVhqrllzXS1vWc6CSu684dIhiQl2XnipQ5A06_Xg0w5PP6DL6OPqvUX-G8NMFUWZFT9recqrPx-JPZx1WFGaW3RjDmNQXeh_DEqagbc3fuWALF6e3M1D11OiDb9aMOLt9HD-JHpuo4F4xOESk2N_clyY7uWRI0lBB8Uw2Z0h6mLv2BQJmpocsbfvpS0bdfCrDLw-QAtUi7Ea4E0TMCqQPnY1G_dnugDeWvqpFwGgnN5IsUj4tr6ublIu61efieYM3s3TFOLu9hQA8mCAVKhK_Qq5CU5t4_omMMt5LJc3TXfpDONhiHVy3AvXu49u9Ovxs8tFJL8j5Vt-1D750rNbetCpO4vO76YyxnsTfLURynOuKXNwaPJvnKWlXs3zgX64.FTSGbHXCTLgOYQrVN0G5NKubNFvlZhcSDSV1oTd_9JA',
      user_id: user_id || '2533274897800701'
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