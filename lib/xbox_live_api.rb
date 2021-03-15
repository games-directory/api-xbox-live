require 'kernel'
require 'xbox_live_api/requests'

class XboxLiveApi
  attr_reader :session_info

  def session_expired?
    @session_info.expired?
  end

  def initialize(token = nil, user_id = nil)
    @session_info = OpenStruct.new(
      token: token || 'XBL3.0 x=17882365792504590677;eyJlbmMiOiJBMTI4Q0JDK0hTMjU2IiwiYWxnIjoiUlNBLU9BRVAiLCJjdHkiOiJKV1QiLCJ6aXAiOiJERUYiLCJ4NXQiOiIxZlVBejExYmtpWklFaE5KSVZnSDFTdTVzX2cifQ.B0talSxxjlV3DXLkkXjHp2Yotpd_o3vV1ev5gAyd9LPvx57Gf5Ph-5HvOND31cnOroITZjabmh-_U2rEJfMlid-6viEFBjB1VbioAChKsMQg-hBTfEPqwUrPYhQTZllBLAai-gbEHXXn0vc6U5TbHmaroid6G5gzNIIwn1ogwSE.xA-znFNXDUVz1tuorUYJTg.C8PKtZmrDAnB8vnjXjoyf0ESz8h3FSVrKV937JhHGw-nRvfKFEZQdXt-XqlXu_Mn70fq6U_X_QgG7umHZ5NUQoViCPvKVfK5yTbWBSDqsU1rvWBy-n5ChbLJAQ2Y64_UPu7M8iSGRSrlrfCzeNHUtZXWDNx43GDJabr8hj_aogxaRE5jG_ZoqydikUDCUxU6GraTkCA8YFKov2gIPH4xjFGhxlOV9VpXio2r1cVMbbXk8xLVYyBIk7nLARyO-gQRQUv-_5QtzaewCgoeG2d0yNR4oS-Y0lo6oiGBaKlBeTNF9PSOpb07uDWC4nzhZqs5tfsADAqu_YIFfP7qiEgykQ2gVUNSnoAuHZRBL5L0hd_wg8e4tsnf_bOTV0P0r91BXwmPzeJJkzG9UsI2DuPeWlXzhC-O9MwAMNCSAfmZy-eE9G7_5yizuaGE3xbb8CyWU2Rm4FkPZF0zEGvELTYCUsgXagkPv26XMUi8GN15Gn86FF_4NQ-7SdtN7KH3QU-X2zhhR8zH8VUhrCoVy2s8tDBb9WQWItBZI8zTFTAJkns19LVmcPES9V5jw7aqWMbcdGgCgrhnSaGF6hN1EU-l8vwUzZEpPB9o6VZEFWCnu6A5tMNbH5zHWh-OaO46no2UFZhUyq-AhL3bqAxdyrYsdO3IEx7lmHZ5oGVV_KHgLGrzNqrirBfVxXw-mtch0dw9T-4c9KZ7shMVKD-pPBFM3_ttA-cxIUrawoj9o3Jz6Po36O-D7JATNMmSNdsMeLo-CQD4ECubf-dfgR9kVS2c2vEp5OWnkyhRwX1OHuReeSaAyRddZZfzVVBwgGG62Lrx-VGlHHEyJtYhuoHh7dIYt8pLveKZMA2dBzen2kOIe99MY_3eKTB5fIqXchv2QwICjaqZ4qjaRPCD9IFjQ1nd_TL3HJuBtIOiuyU9L_ZCAz3fDG8vXMItV6PB1VutEQUJVQhmhxSFAgTGHNxKG6bS39oNq7cTJWjL2d9eq9vPyzCfblVkPylpbWbAaMEgbaoQsxzhDwaP3U_PLH6pePhc-zf_dafeGlP-V0Vw7e1IR-0HQ5y1QOCJJCuXmXjpp5EeJVl0WiCmcUybtXBmk86TVZjqfAA6g2PNa0UXK4wrYZMrwDEspSSEnj_QLs9wKRJv-L20Cy_j8bZ3LzCaoB16HablJFEkhYWKp83wWYrxG2dhrEfXH-8idq-OPjeU8o2lq0CCGo98V2c1VxxvgKHX6izaTno1u-KcGd200-6pRSZ-Tp9Smk3C4cgfMvspFzmZ4FXDAs8GYZiGUr73-iUZP1ceA1MrHxVqE6vTgYSH3XUMbovldYervGvQEUEiO0FDWRCqvUlcnVxzgYnttmMJfSFHKc2FxTV2RIziD2TcC1PCY007ke-Smkm0Zeura1ezEo9TUCnaH4GxuA923rdSOijMts5osevRz7eRpIxwtrhZx-ih3kFDUvmIqTzLgNJ4GjqBdnZkGSyDwm-p1GAtYJkm55aUXInYi-Wjt-XyhlZoCmpB4eM5O-XI6C9VUGUI.1XFruhKIlsYtxvQ3z6nEjaiR2VesECxClNn1nK9Zv2w',
      user_id: user_id || '2533274897800701'
    )
  end

  # NEW
  def people
    Requests::PeopleHubRequest.new(@session_info.token)
  end

  def titles(xuid, offset: 0, limit: 1000)
    Requests::TitleHubRequest.new(@session_info.token).titles(xuid, offset, limit)
  end

  def achievements
    Requests::AchievementsRequest.new(@session_info.token)
  end

  def videos
    Requests::GameClipsMetadataRequest.new(@session_info.token)
  end

  def screenshots
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