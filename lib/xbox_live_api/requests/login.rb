require 'xbox_live_api/requests/http_session_gateway'
require 'xbox_live_api/session_info'
require 'cgi'
require 'uri'

class XboxLiveApi
  module Requests
    class Login
      def initialize(username, password)
        @username = username
        @password = password
        @http_gateway = HttpSessionGateway.new
      end

      def execute
        url = get_request_url
        access_token = get_access_token(url)
        authenticate(access_token)
        authorize
        SessionInfo.new(user_id: @xid, gamertag: @gtg, token: @auth_header, expires: @expires)
      end

      private

      def get_request_url
        params = {
            client_id: '0000000048093EE3',
            redirect_uri: 'https://login.live.com/oauth20_desktop.srf',
            response_type: 'token',
            display: 'touch',
            scope: 'service::user.auth.xboxlive.com::MBI_SSL',
            locale: 'en',
        }

        resp = @http_gateway.get(url_with_params('https://login.live.com/oauth20_authorize.srf', params)).body
        @ppft = resp.match(/sFTTag:.*value="(.*)"\/>/)[1]
        resp.match(/urlPost:'([A-Za-z0-9:\?_\-\.&\/=]+)'/)[1]
      end

      def get_access_token(url)
        params = {
            login: @username,
            passwd: @password,
            PPFT: @ppft,
            PPSX: 'Passpor',
            SI: 'Sign in',
            type: '11',
            NewUser: '1',
            LoginOptions: '1',
            i3: '36728',
            m1: '768',
            m2: '1184',
            m3: '0',
            i12: '1',
            i17: '0',
            i18: '__Login_Host|1',
        }
        resp = @http_gateway.post(url, body: params, follow_redirect: false)

        location_header = resp.headers['lc']
        # CGI::parse(URI::parse(location_header).fragment)['access_token'].first
        return 'EwAgA%2bpvBAAUKods63Ys1fGlwiccIFJ%2bqE1hANsAARwqnpUp9kRxCa6fcBpHUgPsuUTcoVlQKgbu1poEob4fYeysnoHXHmxOBRSP3X4s0k6TbZ0UaOnZKLOITcZMmUIeumj5Px/K9uNO4/CPDUv7aP8peEJiT0WWCp%2b2m5EEg5GzoBxlQKr7rGbhmW99ObJwrtgePPz%2bsS7vhcAXLZZyI3czctanNuozshwO/IfVYEGBzaflBMZyK/Rn93luW8GN3b%2bSyAShAlNX3vHlh/6fupvz8PtHAbyNEuxjdQdCMKn/HUB%2b7hE7Cw7WKVGggSAWqcNw2POb5VCTnXKrhoU78NQP3tST3bU0WDPLcCgYKT4Z5/Tj0GvB9G6yz8uJNxsDZgAACBSyPjJ48XBy8AE3BzQCy/H4iB2P/S3Vjgr9Tx6%2braCMCivSYxYP4JfckbTigFsmri%2bFT29BAL8%2bqcEdxxi3acru7i9eB9D4Uf7U1v8tnf54yiGdc523i8ZEnlLInZ9yNXFcjCFiN4BIXKMbvo1rQ5IyFGN1mXFF5DskYrKGTPCYNl1xCkfq5tOf4OV97Imn%2bO8QIOxHZ2G/gLW9WZ%2b%2bVQcweNoT4CK3Ca3qMT8xLR9RekneVW3i63t247gCb3i9YZ5bdG5R6we8ufD9Nt4necHEEc8H6peCR9vmNSymXZAz8npqdHkCLfZ8Cju1o9%2boEmUs1qulHkwmGVguOpdDswJzL8Lk%2b5Go/w1R/vA/9oThVEhbpio7E/OZjl01jzgX/qcyPYKmDB0Po2bMexVogwIaZO/2VdxlYgaRq9fkc3XQ5FgJs88rh%2bpuoDGbIa6NE/%2bWlZo%2bYZqsw67v8f99T6etefrlP%2bvS5axHhvtIu0veLj1BaJHovAITtlVc6Tm%2b2plCOnBEiDg5uJD3izunanlYDjSa%2bllscpkYJ2wyiUMxTfjC8VlGfp6i0%2bu4WI0EaiUdHv59Kxe22FjWk65rclFtACQmnSx1%2b1ZvlNV36mTviPHecyGcxbiKcDzpdb38HmtmQ43RL%2bfdF%2brANGhxElv2t5s7gZdUNBDzKwI%3d&token_type=bearer&expires_in=86400&scope=service::user.auth.xboxlive.com::MBI_SSL&refresh_token=M.R3_BAY.-CV*U6MMxbwxjaYwWTeRJ3wIPMl42nDL45DC45QSGmGBIVRSvouTirDB3rsiE7CjSBJwe1BSnhbLfs7bCKg7j7g!l3xaXFwJ!bLR3Wl3D1hg7gwP7MME2lK1KaGBjxoAFA0qnagDbaFGFeZtrLmBAu5xvOkiGEAiOm7ARxCgf3*McTWfPsf9ahHJ2qFQgJHLnSisuAbSakNefuRuEcYkXJbeAPU89HWASuMbGANB8ZHOQlXOxbNwgAObJPt!e!jRjNUfucb4SwG!*SHYGCHRAWTk%24&user_id=bd36501cb6543614'
      end

      def authenticate(access_token)
        url = 'https://user.auth.xboxlive.com/user/authenticate'
        params = {
            'RelyingParty' => 'http://auth.xboxlive.com',
            'TokenType' => 'JWT',
            'Properties' => {
                'AuthMethod' => 'RPS',
                'SiteName' => 'user.auth.xboxlive.com',
                'RpsTicket' => access_token,
            }
        }

        resp = @http_gateway.post(url, body: Oj.dump(params), header: {'Content-Type' => 'application/json'})
        json = Oj.load(resp.body)
        @token = json['Token']
        @uhs = json['DisplayClaims']['xui'][0]['uhs']
      end

      def authorize
        url = 'https://xsts.auth.xboxlive.com/xsts/authorize'
        params = {
            'RelyingParty' => 'http://xboxlive.com',
            'TokenType' => 'JWT',
            'Properties' => {
                'UserTokens' => [@token],
                'SandboxId' => 'RETAIL',
            }
        }
        resp = @http_gateway.post(url, body: Oj.dump(params), header: {'Content-Type' => 'application/json'})
        json = Oj.load(resp.body)
        token = json['Token']
        @expires = json['NotAfter']
        @xid = json['DisplayClaims']['xui'][0]['xid']
        @gtg = json['DisplayClaims']['xui'][0]['gtg']
        @auth_header = "XBL3.0 x=#{@uhs};#{token}"
      end

      def url_with_params(url, params)
        URI.escape("#{url}?#{prepare_url_parameters(params)}")
      end

      def prepare_url_parameters(params)
        URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
      end
    end
  end
end
