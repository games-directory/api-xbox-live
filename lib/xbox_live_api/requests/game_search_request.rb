require 'xbox_live_api/requests/base_request'
require 'json'

class XboxLiveApi
  module Requests
    class GameSearchRequest < BaseRequest
      GAME_DETAILS_ENDPOINT ||= 'https://eds.xboxlive.com/media/en-us/singleMediaGroupSearch'

      def for(user_id, query)
        fields = XboxLiveApi::Requests::GameDetailsRequest::ENDPOINT_QUERY_FIELDS.split().join('.')
        query  = {
          q:                      query,
          desired:                fields,
          maxItems:               10,
          desiredMediaItemTypes: 'Xbox360Game',
          domain:                'Xbox360'
        }

        response = HttpSessionGateway.new.get(GAME_DETAILS_ENDPOINT, query: query, header: eds_header_for_version())

        return JSON.parse(response.body)['Items']
      end
    end
  end
end