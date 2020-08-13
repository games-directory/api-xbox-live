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
        return 'EwAYA%2bpvBAAUKods63Ys1fGlwiccIFJ%2bqE1hANsAAV0tx7H933nCWO3YdUkXN9xSS2vDsq2y0EGd50NOxYbT8o3XDkM4K4dG4s0lZk12J50%2bilVa/j1BH1xTu4teKC58V6O6fS30FhrxttNyidvdQEXN1rVM5GfjtT3SKCWvw0PaaMDB1pHkpsbs87fq%2bZ4/mtYMkAerDd47ljWHR0tF3H00QfJLDUBIOZgwb9FByc/JcQhonbwBwL00qMzjudxjPJExwB47h4qjhuDs3Ps2AgGK/ZMLIE7Nnd3qFaaCIohNfl/sBlsReLp8MnazxkRqMlOvEG8DaFqlZQHGgkzlAflYYG5qeoJcFxaWjcPAohg0iIqYBxvjX4H5w9E4WzADZgAACIy5En/raGhL6AGVn3sfE5wua%2bRWoxLhtBtIzQPz4l5rejVNewKW4ogBNbKxRl2FJwKi2NiOotlujF8uKkLPhrZ0NWzNfm7u99gkSmIdTKColCoWQAhCkysYjEStWeikthBfSgjxl67qMr2q9iH4Hg4MU7BYQ4iAAsQrpuOEGFzT7LQDJ1ouqLJYpYpFpNYXZpSN59kBGFHHi2tQAFUcLjvygeqs2ydE124CJrSkSaPX4dsdusoyTorSX7eL7BijAFR2s56EzgqVlhFWDYiUZ4wmdrkuonQYmULe9Ut/O6w%2bYUIDOYRuYBJACM9vDNxJEvBM%2bWhSe1vjwou9jWAsS5S98CDcl/gcOttSODwtJsaFhIUBgmbLgs4g5FV5i3Ot8%2bv5kAIgvGYcfQfcjfw72FLjKfO69LoDRpb1qTsVYNE/jMujJ7bpCUWoNBbyLRiseSqEZ2BUUqoyyDvKzqxmzWXzQyPo9AxNrtKh8L166m5gMu1U/pmMtM9afgD3ddOKDxY%2bUvgJgzEXxxD//aSNy9syZvx9QWWqi0ub3atKkdg1PuWbxBbfO7ZUO9djdwEMBJ1XbIV8fK0ZVeLmIPZX67nSN40tGvna8oBZXZW/fku4CaNf8OKMmsElx3H0VON2gDeNQ3bhD7hzvdbK/vR9NXu4uSsC&token_type=bearer&expires_in=86400&scope=service::user.auth.xboxlive.com::MBI_SSL&refresh_token=MCbybFhM2!NR5JTzuVtm2fIjrcZRUmeWrBuf!8YVvYorMvr5TkJ3OUCcpYmeFz5IaMgCYAVVr1UqqKyD0wXxpblMXukzFcTVTbDtwQM6Lz8Amecz4rGs7GcaiYHakcACgzjeCEgT246kDvifwCNtOF!8rn08Z3bzzWbj01qgZIwq1OIXcoFDrBbpddLvYOIbg47ABNoXM4*qwXEifWJmxldo6QH82!7LaaE!fZhHO8!qBvofozQMfyRSTPy1t5t60DTvTaPBh59uUUgNAJ*Q1OYlrDghos1TIZbLBF9WtBUpBSYh5eYFIylhazrVK8FoxkuRRoAHfsUppRp8ORmZEaO0VM4w7wCLpCtvPMPHaUQ!v&user_id=bd36501cb6543614'
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
