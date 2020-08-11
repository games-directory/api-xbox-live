require 'xbox_live_api/requests/base_request'
require 'json'

class XboxLiveApi
  module Requests
    class PresenceRequest < BaseRequest
      PRESENCE_ENDPOINT ||= 'https://userpresence.xboxlive.com/users/xuid(%s)'

      def for(user_id)
        response = HttpSessionGateway.new
          .get(
            format(PRESENCE_ENDPOINT, user_id),
            header: header_for_version(Version::XBOX_ONE),
            body: nil
          )

        return JSON.parse(response.body)
      end
    end
  end
end
