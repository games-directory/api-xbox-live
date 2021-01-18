require 'xbox_live_api/requests/base_request'
require 'xbox_live_api/profile'
require 'oj'

class XboxLiveApi
  module Requests
    class ProfileRequest < BaseRequest
      PROFILE_V1_ENDPOINT ||= 'https://profile.xboxlive.com/users/batch/profile/settings'
      PROFILE_V2_ENDPOINT ||= 'https://peoplehub.xboxlive.com/users/%s/batch/profile/settings'

      def for(user_id)
        resp = make_request(user_id)
        handle_response(resp, user_id)
      end

    private

      def make_request(user_id)
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
          'userIds' => [user_id]
        }

        HttpSessionGateway.new
         .post_json(PROFILE_V1_ENDPOINT,
           header: header_for_version(Version::XBOX_ONE),
           body: params
         ).body
      end

      def handle_response(resp, user_id)
        json = Oj.load(resp)
        settings = json['profileUsers'].first['settings']
        settings_hash = collect_settings(settings)

        return json
      end

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
