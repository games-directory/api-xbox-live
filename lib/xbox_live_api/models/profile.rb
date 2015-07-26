require 'xbox_live_api/models/common/my_comparable'

class XboxLiveApi
  class Profile < MyComparable
    attr_reader :id, :gamertag, :gamerscore, :gamer_picture, :account_tier,
                :xbox_one_rep, :preferred_color_url, :tenure_level

    def initialize(id: nil, gamertag: nil, gamerscore: nil, gamer_picture: nil, account_tier: nil,
                   xbox_one_rep: nil, preferred_color_url: nil, tenure_level: nil)
      @id = id
      @gamertag = gamertag
      @gamerscore = gamerscore
      @gamer_picture = gamer_picture
      @account_tier = account_tier
      @xbox_one_rep = xbox_one_rep
      @preferred_color_url = preferred_color_url
      @tenure_level = tenure_level
    end

    protected

    def state
      [@id, @gamertag, @gamerscore, @gamer_picture, @account_tier,
       @xbox_one_rep, @preferred_color_url, @tenure_level]
    end
  end
end