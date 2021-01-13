require 'xbox_live_api/requests/http_session_gateway'
require 'xbox_live_api/session_info'
require 'cgi'
require 'uri'
require 'httparty'

class XboxLiveApi
  module Requests
    class Login
      include HTTParty

      USER_AGENT = [
        'Mozilla/5.0 (games.directory/2.0; XboxLiveAuth/3.0)',
        'AppleWebKit/537.36 (KHTML, like Gecko)',
        'Chrome/71.0.3578.98 Safari/537.36'
      ].join(' ').freeze

      DEFAULT_SCOPES = [
        'Xboxlive.signin',
        'Xboxlive.offline_access'
      ]

      CLIENTS = {
        MY_XBOX_LIVE: '0000000048093EE3',
        XBOX_APP: '000000004C12AE6F',
        MINECRAFT_APP: '000000004'
      }.freeze

      def initialize(username, password)
        @username = username
        @password = password

        @http_gateway = HttpSessionGateway.new
      end

      def execute
        token, uhs = authenticate(access_token)
        issued_at, xid, gtg, token, expires_at = authorize(token, uhs)

        SessionInfo.new(
          issued_at: issued_at,
          user_id: xid,
          gamertag: gtg,
          token: token,
          expires: expires_at
        )
      end

      def oauth2_token_request()
        client_id =
        client_secret = 

        params = {
          client_id: client_id,
          response_type: 'code',
          approval_prompt: 'auto',
          scope: DEFAULT_SCOPES.join(' '),
          redirect_uri: 'http://localhost:3000/my_auth/xbox'
        }

        url = "https://login.live.com/oauth20_authorize.srf?#{ URI.encode_www_form(params) }"

        puts url
        puts 'Please input your code: '
        code = gets.strip

        request = self.class.post("https://login.live.com/oauth20_token.srf",
          body: {
            grant_type: 'authorization_code',
            code: code,
            client_id: client_id,
            client_secret: client_secret,
            scope: DEFAULT_SCOPES.join(' '),
            redirect_uri: 'http://localhost:3000/my_auth/xbox'
          }
        ).parsed_response

        user_auth = {
          token_type: request['token_type'],
          expires_in: (Time.now + (request['expires_in'] || 0)),
          scope: request['scope'],
          access_token: request['access_token'],
          refresh_token: request['refresh_token'],
          user_id: request['user_id'],
          issued_at: DateTime.now.to_s
        }
        puts request
        authenticate(request['access_token'])
      end

    private

      # def pre_auth
      #   request = self.class.get('https://login.live.com/oauth20_authorize.srf',
      #     query: {
      #       client_id: CLIENTS[:MY_XBOX_LIVE],
      #       redirect_uri: 'https://login.live.com/oauth20_desktop.srf',
      #       response_type: 'token',
      #       display: 'touch',
      #       scope: 'service::user.auth.xboxlive.com::MBI_SSL',
      #       locale: 'en'
      #     },
      #
      #     headers: {
      #       'Accept-Language': 'en-US',
      #       'User-Agent': USER_AGENT
      #     }
      #   )
      #
      #   cookie = (request.headers['set-cookie'] || [])
      #    .split(',')
      #    .map { |cookie| cookie.split(';')&.first }
      #    .join(';')
      #
      #   ppft = request.body.match(/sFTTag:.*value="(.*)"\/>/)[1]
      #   url = request.body.match(/urlPost:'([A-Za-z0-9:\?_\%2F\-\.&\/=]+)'/)[1] rescue nil
      #
      #   raise "Couldn't find a valid URL for retrieving the 'access_token'; cannot continue" if url.nil?
      #
      #   return cookie, ppft, url
      # end

      # def access_token
      #   cookie, ppft, url = pre_auth
      #
      #   request = self.class.post(url,
      #     body: {
      #       login: @username,
      #       loginfmt: @username,
      #       passwd: @password,
      #       PPFT: ppft
      #     },
      #
      #     headers: {
      #       'Cookie': cookie,
      #       'User-Agent': USER_AGENT
      #     },
      #
      #     follow_redirects: false
      #   )
      #
      #   raise "URL did not redirect, which is usually caused by 2-factor authentication enabled; cannot continue" unless request
      #
      #   CGI::parse(
      #     URI::parse(
      #       request.headers['Location']
      #     ).fragment
      #   )['access_token'].first
      # end

      def authenticate(access_token)
        body = {
          'RelyingParty' => 'http://auth.xboxlive.com',
          'TokenType' => 'JWT',
          'Properties' => {
            'AuthMethod' => 'RPS',
            'SiteName' => 'user.auth.xboxlive.com',
            'RpsTicket' => access_token
          }
        }
        headers = {
          'x-xbl-contract-version' => '1'
        }

        url = 'https://user.auth.xboxlive.com/user/authenticate'
        request = self.class.post(url, body: body, headers: headers, debug_output: $stdout)

        binding.pry
        token = request['Token']
        uhs = request.dig('DisplayClaims', 'xui', 0, 'uhs')

        return token, uhs
      end

      def authorize(token, uhs)
        request = self.class.post('https://xsts.auth.xboxlive.com/xsts/authorize',
          body: {
            RelyingParty: 'http://xboxlive.com',
            TokenType: :JWT,
            Properties: {
              UserTokens: [token],
              # DeviceToken: '',
              # TitleToken: '',
              # OptionalDisplayClaims: [''],
              SandboxId: :RETAIL,
            }
          }.to_json,

          headers: {
            'Content-Type': 'application/json',
            'User-Agent': USER_AGENT
          }
        ).parsed_response

        issued_at = request['IssueInstant']
        expires_at = request['NotAfter']
        xid = request.dig('DisplayClaims', 'xui', 0, 'xid')
        gtg = request.dig('DisplayClaims', 'xui', 0, 'gtg')
        token = "XBL3.0 x=#{ uhs };#{ request['Token'] }"

        return issued_at, xid, gtg, token, expires_at
      end
    end
  end
end