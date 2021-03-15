require 'xbox_live_api/requests/base_request'
require 'httparty'

class XboxLiveApi
  module Requests
    class AchievementsRequest < BaseRequest
      include HTTParty

      base_uri 'https://achievements.xboxlive.com/users'
      
      # {
      #   'x-xbl-contract-version' => 1 # X360 Achievements
      #   'x-xbl-contract-version' => 2 # XONE Achievements
      #   'x-xbl-contract-version' => 3 # X360 Achievements; it also includes rarity data
      #   'x-xbl-contract-version' => 4 # XONE Achievements; it also includes rarity data
      # }
      
      # @public
      # Provides access to user achievements defined on the title, those unlocked by the user, or those the user has in progress.
      # 
      # xuid 64-bit unsigned integer
      # => Xbox User ID (XUID) of the user whose (resource) is being accessed. Must match the XUID of the authenticated user ( not really, you can pass any XUID :) ).
      #
      def all(xuid, platform: :xone, offset: 0, limit: 10000)
        raise 'Too many, max limit is 10000' if limit >= 10001
        
        # https://achievements.xboxlive.com/users/xuid(2533274897800701)/achievements?maxItems=10000
        self.class.get("/xuid(#{ xuid })/achievements",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => (platform == :xone ? 4 : 3)
          },
          params: {
            maxItems: limit
          }
        )
      end

      # @public
      # Returns details about the achievement, including its configured metadata and user-specific data.
      #
      # @xuid 64-bit unsigned integer
      # => Xbox User ID (XUID) of the user whose resource is being accessed. Must match the XUID of the authenticated user.
      # 
      # @scid GUID
      # => Unique identifier of the service configuration whose achievement is being accessed.
      # 
      # @achievement_id 32-bit unsigned integer
      # => Unique (within the specified SCID) identifier of the achievement that is being accessed.
      #
      def get(xuid, scid, acheivement_id, platform: :xone)
        
        # https://achievements.xboxlive.com/users/xuid(2533274897800701)/achievements/cb2c0100-03d5-4913-8391-3f20032170b5/1
        self.class.get("/xuid(#{ xuid })/achievements/#{ scid }/#{ achievement_id }",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => (platform == :xone ? 2 : 1)
          }
        )
      end
    end
  end
end