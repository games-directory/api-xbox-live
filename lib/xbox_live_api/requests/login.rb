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
        return 'EwAYA%2bpvBAAUKods63Ys1fGlwiccIFJ%2bqE1hANsAAXVfTicT8vq4%2bt9BTynblKiJ6w1Rrh/T9q4dW22ECKJkXroJ5H8Z7gFHCl%2bNE5upZ3uQCHbJbeNqySyQzK2ieMFhGeeh3i75aeHF2MbfjQn1xrnNAPgRozMdMNy2aXPbEB3h5PuHnW7K6qbl0QjzHjZrWmmSlHokJAIfmVnAFQFIpAtidD31vr1iN%2bcpYBQAMLTPAzBUhVsiwz0hfwSlx9Y7e7AvsIT2kuYWQEOy0jB5HcHBHGgWWMw62yJabUdzQRzn4qaQgd%2b2sS0l4Es2ljdi3Fo112EF7PaKT00U%2bNmbVEgpFLP9ebf3XhOc9OAqQHh69l6RYXadliwc03QFiGwDZgAACO3C/muTANA96AEAA73b2u9sF0BvZPHL4J81SSvrTDdVHAcJ162PeocQDFeVNfqnGXLjPbt1a/e633yKeYRj7HcaP/e%2bzu7lrjMjGwVU7SudNsxpBrFPRWrs3NtxhaRRmRCLFViT4O0TP%2bPKhpjFH83BaEj7fuAEp2K69Aen0wf1aI0Yx1SoUV6KIGmN2/ahRqrr/LIRFuEWVvh%2bnu9W0z/UFfaGeTNpvVMjLH8Tcc/9/GJwXSX3giibkNz824/02lam5714iMyheR34/SNYsD/oh8URYlaFsUxi7phrd2Y4sG%2bJT1C7PkZOKfMMk2cE4N6dlNtPKS8lmSK1CH/KEBkhNazq4S6flNo8PMMOlDvj%2bdBs5JAnUYlUz8PYpj5dAaxWUnClWxLPuKwIcT7Y2dMpZk5EHamTm7H0F8cjeo4qfOlaRAAl3mc5f6X357ErayYxG9QLqTkwkebGGYltoyeJhfhDCLbvHIzZTgE/KGJrIq0uQqWqNITPJnNIT%2bKyiQ%2bpg7%2blDXjsFlQ5I%2bC83ghxmiWNTgJII9KOxo/2LQkiFRvw08Qd53vXxI16%2b7Q/QMCjZPwFMNKK0%2bg1UPCxWX605Zptn5lMk%2bpvixk99Z6raCsH0EzDV6GpvfaqcchAKF9l2IytGdE3Vh0i8zMJ1FprTSsC&token_type=bearer&expires_in=86400&scope=service::user.auth.xboxlive.com::MBI_SSL&refresh_token=MCQrpAr8w9KzDD6!SuWSIYycDrbggrSXMMKl3eZBbrkZctDW*2MxQyukzUckpeB3cjL5OCJEKZwu5dtZu9LQZ2HOQyLM0vIuQfOMJnAeCehCsrmn7Xv20HlxG8wCQ2GhSqnnJOLfq9qf0vZbRzWIhFw8GxXAty41W3PTmY7vsW*JzXeQzwyO5yzFJNYhYGPaadCr2sdGUeq3slk*YULbfYsamQdl1A661!r!1ma4eqNmne0lKGchCE9mzYwxCx6W3qyk!i*8TWaR2UmJra4tx!o8wpsg7VFgvPJyHvHo2KvkKbe4tFz1cAaHPdj2DwVql2YXoBEDwEY08wwr5T1G4ri8T154*fj3zCFlsY1flTfEQ'
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
