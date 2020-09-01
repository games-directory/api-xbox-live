class XboxLiveApi
  module Requests
    class BaseRequest
      class Version
        XBOX_360 = 1 # 3
        XBOX_ONE = 2 # 4
        WINDOWS  = 3.2
      end

      def initialize(auth_header)
        @auth_header = auth_header
      end

      def header_for_version(version)
        {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Authorization' => @auth_header,
          'x-xbl-contract-version' => version
        }
      end

      def eds_header_for_version()
        {
          'Accept'                   => 'application/json',
          'Authorization'            => @auth_header,
          'x-xbl-contract-version'   => '3.2',
          'x-xbl-device-type'        => 'WindowsPhone',
          'x-xbl-client-version'     => '2.0',
          'x-xbl-client-type'        => 'Companion',
          'x-xbl-isautomated-client' => 'true'
        }
      end
    end
  end
end