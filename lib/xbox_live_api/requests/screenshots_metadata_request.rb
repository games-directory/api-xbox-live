require 'xbox_live_api/requests/base_request'
require 'httparty'

class XboxLiveApi
  module Requests
    class ScreenshotsMetadataRequest < BaseRequest
      include HTTParty

      base_uri 'https://screenshotsmetadata.xboxlive.com'
      
      # @public
      # https://screenshotsmetadata.xboxlive.com/users/xuid(2535443165777296)/screenshots?maxItems=1000
      # https://screenshotsmetadata.xboxlive.com/users/xuid(2535443165777296)/titles/972249091/screenshots?maxItems=1000
      def recent(xuid = nil, title_id: nil, skip_items: 0, offset: nil, limit: 1000)
        self.class.get("/users/#{ xuid ? "xuid(#{ xuid })" : 'me' }#{ title_id ? "/titles/#{ title_id }" : '' }/screenshots",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => '5'
          },
          query: {
            skipItems: skip_items,
            continuationToken: offset,
            maxItems: limit
          }
        )
      end
      
      # @public
      # https://screenshotsmetadata.xboxlive.com/public/titles/972249091/screenshots
      def saved(xuid = nil, title_id: nil, skip_items: 0, offset: '', limit: 1000)
        self.class.get("/users/#{ xuid ? "xuid(#{ xuid })" : 'me' }#{ title_id ? "/titles/#{ title_id }" : '' }/screenshots/saved",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => '5'
          },
          query: {
            skipItems: skip_items,
            continuationToken: offset,
            maxItems: limit
          }
        )
      end

      # @public
      # https://screenshotsmetadata.xboxlive.com/public/titles/972249091/screenshots
      def community_recent(title_id, skip_items: 0, offset: '', limit: 1000)
        self.class.get("/public/titles/#{ title_id }/screenshots",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => '5'
          },
          query: {
            skipItems: skip_items,
            continuationToken: offset,
            maxItems: limit
          }
        )
      end

      # @public
      # https://screenshotsmetadata.xboxlive.com/public/titles/972249091/screenshots/saved
      def community_saved(title_id, skip_items: 0, offset: '', limit: 1000)
        self.class.get("/public/titles/#{ title_id }/screenshots/saved",
          headers: {
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => '5'
          },
          query: {
            skipItems: skip_items,
            continuationToken: offset,
            maxItems: limit
          }
        )
      end
    end
  end
end