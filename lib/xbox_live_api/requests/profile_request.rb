require 'xbox_live_api/requests/base_request'
require 'json'

class XboxLiveApi
  module Requests
    class ProfileRequest < BaseRequest
      PROFILE_ENDPOINT ||= 'https://profile.xboxlive.com/users/batch/profile/settings'

      def for(user_id)
        params = {
          'settings' => %w(Gamerscore Gamertag GameDisplayPicRaw AccountTier XboxOneRep PreferredColor TenureLevel Motto Bio Location),
          'userIds' => [user_id]
        }

        response = HttpSessionGateway.new
          .post_json(PROFILE_ENDPOINT,
            header: header_for_version(Version::XBOX_ONE),
            body: params
          )

        response = JSON.parse(response.body)

        identity = {
          'id' => response.dig('profileUsers', 0, 'id'),
          'isSponsoredUser' => response.dig('profileUsers', 0, 'isSponsoredUser')
        }.merge(
          pretty_key_value(response.dig('profileUsers', 0, 'settings'))
        )

        return identity
      end

    private

      def pretty_key_value(settings)
        settings_hash = {}

        settings.each do |setting|
          settings_hash.store(setting['id'], setting['value'])
        end

        settings_hash
      end
    end
  end
end
