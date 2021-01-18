require 'xbox_live_api/requests/base_request'

class XboxLiveApi
  module Requests
    class ProfileRequest < BaseRequest
      PROFILE_V1_ENDPOINT ||= 'https://profile.xboxlive.com/users/batch/profile/settings'
      PROFILE_V2_ENDPOINT ||= 'https://peoplehub.xboxlive.com/users/%s/batch/profile/settings'

      def for(user_ids)
        user_ids.class.name
        params = {
          'settings' => %w(
            AccountTier AppDisplayName AppDisplayPicRaw
            Bio
            IsQuarantined
            Location
            ModernGamertag ModernGamertagSuffix
            GameDisplayName GameDisplayPicRaw Gamerscore Gamertag
            Motto
            PreferredColor PublicGamerpic
            RealName RealNameOverride
            ShowUserAsAvatar
            TenureLevel
            UniqueModernGamertag
            XboxOneRep
            Watermarks
          ),
          'userIds' => user_ids
        }

        profiles = []

        request = HttpSessionGateway.new
          .post_json(PROFILE_V1_ENDPOINT,
            header: header_for_version(Version::XBOX_ONE),
            body: params
          )

        response = request.body

        JSON.parse(response)['profileUsers'].each do |remote_profile|
          profile = collect_settings(remote_profile['settings'])

          profile['id'] = remote_profile['id']
          profile['isSponsoredUser'] = remote_profile['isSponsoredUser']

          profiles << profile
        end

        profiles.length > 1 ? profiles : profiles.first
      end

    private

      # Transform the hash returned by the API into a key => value object
      #
      def collect_settings(settings)
        settings_hash = {}

        settings.each do |setting|
          settings_hash.store(setting['id'], setting['value'])
        end

        settings_hash
      end
    end
  end
end
