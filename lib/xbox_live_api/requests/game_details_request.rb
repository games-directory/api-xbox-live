require 'xbox_live_api/requests/base_request'
require 'json'

class XboxLiveApi
  module Requests
    class GameDetailsRequest < BaseRequest

      GAME_DETAILS_ENDPOINT ||= 'https://eds.xboxlive.com/media/en-US/details'
      ENDPOINT_QUERY_FIELDS ||= '
        TitleId
        ReleaseDate
        Description
        ReducedDescription
        ReducedName
        Images
        DeveloperName
        PublisherName
        ZuneId
        AllTimeAverageRating
        AllTimeRatingCount
        RatingId
        UserRatingCount
        RatingDescriptors
        SlideShows
        Genres
        Capabilities
        HasCompanion
        ParentalRatings
        IsBundle
        BundlePrimaryItemId
        IsPartOfAnyBundle
        VuiDisplayName
        Updated
        ParentalRating
        ParentalRatingSystem
        SortName
        HexTitleId
        ThirtyDaysRatingCount
        SevenDaysRatingCount
        ThirtyDaysAverageRating
        SevenDaysAverageRating
        LegacyIds
        Availabilities
        ResourceAccess
        IsRetail
        ManualUrl
      '

      def for(user_id, ids, platform, type)
        query = {
          ids:            ids.join(','),
          desired:        ENDPOINT_QUERY_FIELDS.split().join('.'),
          IdType:         (type == :hex ? 'XboxHexTitle' : 'Canonical')
        }

        if platform == 'xbox_360'
          query[:domain] = 'Xbox360'
          query[:desiredMediaItemTypes] = 'Xbox360Game'
        elsif platform == 'xbox_one'
          query[:targetDevices] = 'XboxOne'
          query[:mediaGroup] = 'GameType'
          query[:domain] = 'Modern'
        else
          '...'
        end

        response = HttpSessionGateway.new.get(GAME_DETAILS_ENDPOINT, query: query, header: eds_header_for_version())

        if ids.size > 1
          return JSON.parse(response.body).dig('Items')
        else
          return JSON.parse(response.body).dig('Items', 0)
        end
      end
    end
  end
end