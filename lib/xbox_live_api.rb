require 'kernel'
require 'xbox_live_api/requests'

class XboxLiveApi
  attr_reader :session_info

  def session_expired?
    @session_info.expired?
  end

  def initialize(token = nil, user_id = nil)
    @session_info = OpenStruct.new(
      token: 'XBL3.0 x=10838014312478441562;eyJlbmMiOiJBMTI4Q0JDK0hTMjU2IiwiYWxnIjoiUlNBLU9BRVAiLCJjdHkiOiJKV1QiLCJ6aXAiOiJERUYiLCJ4NXQiOiIxZlVBejExYmtpWklFaE5KSVZnSDFTdTVzX2cifQ.Wt3V5Zrh88mwSCm6tJK_A1QaoLY7S1Ilf_jekacL5YHW5fljrA0NmqfaF0ZlTy1FVn63MBGjSLuAjvmOajOv5htZujgcAKhNiHzzAWN5mkoGZQbaVVmjT2QztayPpr1FCqqVbNZXL_RHPoJoldIBcUCmR2mHza0ItaBjvFg3hFQ.7efO7M_UlbXQDzyLW_OyEg.CVmkWX1hiz7EDWBL_e0JBHqHpTmDpVCu96evEvaI0fAX0tDTJ-4YCRfbQzZdxxcmmLs23bmfBpqJGreMQ6kSC6oiQETVkabyOS8cw-Wyvg2zee5pCVqahVloFK0kTUeMlThPpd0psL2QgNiip4gpJqbd_hVqSis-pcxpBLydVACn2gq66B2JXGzYUgX43MY9aErUHvyyZRtENuCPgBfQcB8HSHiVZTxG-qYIbm4r58a8Osk-eLJKaxFjFm21szHD_UE3cNEBpUPj6VqlP5pK6e9zK4gfvZIp7RziXzDyCcn6iwbCiNBKFkdn7gszhB-FYt4yoaaeS2EnDcTreVrd3hzkw3JDnMk65B7zWmQZsQif885pF5w9S9Ftr9KK2z1kVAHbieUP09uuJEBgMED_iq0qsixZhSPR1CpCl38Ln7mjhyp2fRvr9i7J5TzuXdQEOjqhsXTlLF349UNWlh7HfZo0rqoCQyG9ROFzDKuQime3iGKn7le5cx4xDV4of2eov9QxLTkZsNlTxmgZEIQe2fOEY1DnlDPcLAO6QH1KoItfgXi4UwkdYCMGaEkTHpgXlFTc-ilRHkRlLJYVP1-17UwMaq8YRehN6JOBjZCBPETY175XcDH4F2TGq-jKa7BYAKz9SHv87kqWPUoteosnjlvQWP2Gw9fpLF4Edks1HRjVpZz7tmB7Ozrdk7HHKv_UKNIptuMX0bUQ0G-z_sb443bwVwQuqS8jNCj_-1fp3u8Yp2-bvZt80Mk7XW5CJJqxp2Q9lETG7Y3VLVfDO75l3pNNCvUjJR4G3HztvsY9z6wK8rE41zXA4hA_hdgprf0V3zGSmdTLw_VxaDM2hQQslE4A0IxYa7sqk-y3dmuCdB2mDbLPi1dbOsn9rIIb46x1s6hUYL3laKG3JsXFXfF-8XJkYJUgIbYqD3_h4EUsKKD_rT4gxemAwf9F1klwWk34PoxJHgKZmp88Sy4tyAOCnjP-SQgxIsXj2I2DMVyIxp5fZZFP5PwW72xNdtDWi5ogN5GmBZnEVEkrXSKIfexiVZhIU-DIySN5xf9lkwLGiAK0FGZ_jVKg-zNrNxJpl4LOIhKKd_61-wM_sVCYBVmhGa8zg0JeVJneIh31Dj_oHeqbZ0Gf_ViLjN2ZhPtJ_RTXRf_Vvf8xsSOadBZSqXXpZFE70ZSbONPAToFj5zmUjiY_FSCS-wwuJ-eAbc4_fziwQI51h5SWpgGbuBLx_4KnkhoDThoYz_nJu2AQ865CdbsICinYH4MO2mPSpce8MELeC_-e-WNG992o5A2rfXNyrkYDO93tL-cLuMGDOXBcFwV7CBtdpxgYAKsPUpfTTY19BOiTH6xb5oLMZHa53rswaZ4SU9RICYsF06YV3pDsLgHClqYz4ugJkJhJ-LG8UGzb-3NnQ3Yr-BFpXMZ4RszwH0O8w6cnf4fAqsEGvDT9qBV6sBm97esduRLKILsE75LI_WgkCaIF6Kzl0tLFkr1vx7CV8HCp7HOQrHwB8uMM32c.b5tvbt2VQRi-ikXgJGRDcPGFMnKTY11D84uvWIMVuLc',
      user_id: '2533274897800701'
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