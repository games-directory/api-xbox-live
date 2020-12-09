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
        return 'EwAYA%2bpvBAAUKods63Ys1fGlwiccIFJ%2bqE1hANsAAZMbmAoYrjrnyuD8N%2bg8V/2dIin4g5SsgNjvpa7g5TJnVtUIXo0Ua52BJVj2arC2xDU1f1kzNal%2bjM6N81SRJGbFr8YygjfbGwF9aYpGVA4YBZjJC/o6UYH3PCOt5RjpVAIOsxzhAbW%2bJPcNOwIHuAWJAwYMn%2bQkFt7bDZ6FuqiOXfTZ8GzUILh/Bp0ZItL6m0mmXP1OYCYOHbE3u/dL0TnltiksXTuBbUFC5BNkujmqS16TPjiZF%2bJCqTArNXOtl331WsmzxmkpnthN9sA7rO5fHvq7ECLhM9cHInLt88AJjO9uZ7KQSPh7uSRXtQ996ccfhgpS%2bUE9caVMvdWwC3cDZgAACEm46KolCF1I6AEv8GoVueh/n7s7p/NXz8Jdg7%2b8RbuYvjtnllJNtbL2Tuy0WEcnre16ggP2nKYYSRjhPXjvxTfGII6t7%2bZlPz/9%2bSqhmQ7XD6KzTds8i1qa5NEeQcmMkopxKrga%2b6iMLQkrL8iiO52XOXTU2inVl733n4vuc/mf/8W%2bNnmdZJ48MpYlYseDdGYUEEwi7fJiHaRXOwMvReYp7M7xFcaFkB7ie%2bbUm1ULOgsRJ%2bwtJ3u/ePavdJkECpf1nrZfISY8JGo//Mc5L%2bZvRsNBVZHXFzl4rjhc1ik0ddBs0mVUgvtRk5g4ATuehdOz4M1iE4Uq60UbNYI0YySSUgkaJ9ADeQkD14Q2DaAm%2bhOaIumRvYLyjj120xl/aIvDhhkdTv7sa23MtlBeR6VuOluzwyEQnK52TMunOabLQMuR%2b94znVEroQc%2bi%2b7IdbIx6WbGuHLPjReF659F64qdQ/9vvIWSrvIbu7GmT29RcYGCIfT2F0BrNWLLrYS9J1vRptT7P3aqpqQXhvRMJns61vlr%2bmCD7bjMMYme5CdcZXy4NLq%2bgiSS0JgBia1H33LB7MYtHf%2bw0IkMa9gOU9TGrwZTdBdE4g8P1hYcKRhcTMhVhWgPc%2bKggRv4wFNQkbzeyYDsrz9BORD25ZVahsgvIisC&token_type=bearer&expires_in=86400&scope=service::user.auth.xboxlive.com::MBI_SSL&refresh_token=M.R3_BAY.CbcfJFYrHIIaMl2Q07jqieCGpo22*!0Tvu8MfjpRxdix1m*x8NArMxT5bDsheMqSB0DBofWWGApMoVbsa2CAPZB9YIgew5TcOC7OzF6!*CXPbf9ht!XbcgQNiHym0J1eepExijx4ASvAl7k8C2TFhPIKk6xqBWVcCWXSBZfKcro4B3Zn7WVG1dICThYpIs8DrWFYBefjQ2cBDlmIFQhV83QxTCE1f07YWAPtrekjmvQloGaPAE6!3oJatiZGebqAVxLCKPbYo0phStVUMRH2pOI3XlC3FJLGHkkW3SgQOi8ajHQ947YE5IL16Q!zj7WV2qADYsDHCJjZmj5veVRu66TZkSzTYbT3wWP9ETVEJuGt&user_id=bd36501cb6543614'
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
