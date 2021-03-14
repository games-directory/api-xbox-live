require 'xbox_live_api/requests/base_request'
require 'httparty'

class XboxLiveApi
  module Requests
    class GameClipsMetadataRequest < BaseRequest
      include HTTParty

      debug_output $stdout
      base_uri 'https://gameclipsmetadata.xboxlive.com'
      
      # @public
      # https://gameclipsmetadata.xboxlive.com/users/xuid(2535443165777296)/clips?maxItems=1000
      # https://gameclipsmetadata.xboxlive.com/users/xuid(2535443165777296)/titles/972249091/clips?maxItems=1000
      def recent(xuid = nil, title_id: nil, skip_items: nil, offset: nil, limit: 1000)
        self.class.get("/users/#{ xuid ? "xuid(#{ xuid })" : 'me' }#{ title_id ? "/titles/#{ title_id }" : '' }/clips",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => '1'
          },
          params: {
            # 'skipItems': skip_items,
            continuationToken: offset,
            maxItems: limit
          }
        )
      end
      
      # @public
      # https://gameclipsmetadata.xboxlive.com/public/titles/972249091/clips
      def saved(xuid = nil, title_id: nil, skip_items: nil, offset: '', limit: 1000)
        self.class.get("/users/#{ xuid ? "xuid(#{ xuid })" : 'me' }#{ title_id ? "/titles/#{ title_id }" : '' }/clips",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => '1'
          },
          params: {
            # 'skipItems': skip_items,
            continuationToken: offset,
            maxItems: limit
          }
        )
      end

      # @public
      # https://gameclipsmetadata.xboxlive.com/public/titles/972249091/clips
      def community_recent(title_id, offset: '', limit: 1000)
        self.class.get("/public/titles/#{ title_id }/clips",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => '1'
          },
          params: {
            # 'skipItems': skip_items,
            continuationToken: offset,
            maxItems: limit
          }
        )
      end

      # @public
      # https://gameclipsmetadata.xboxlive.com/public/titles/972249091/clips/saved
      def community_saved(title_id, offset: '', limit: 1000)
        self.class.get("/public/titles/#{ title_id }/clips/saved",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => '1'
          },
          params: {
            # 'skipItems': skip_items,
            continuationToken: offset,
            maxItems: limit
          }
        )
      end
    end
  end
end