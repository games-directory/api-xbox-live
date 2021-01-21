require 'httpclient'
require 'xbox_live_api/requests/http_response'
require 'oj'

class XboxLiveApi
  module Requests
    class HttpSessionGateway

      def initialize
        @client = HTTPClient.new
      end

      def get(uri, query: nil, body: nil, header: nil, follow_redirect: nil)
        resp = @client.get(uri, query: query, body: body, header: header, follow_redirect: follow_redirect)
        transform_response(resp)
      end

      def post(uri, query: nil, body: nil, header: nil, follow_redirect: nil)
        resp = @client.post(uri, query: query, body: body, header: header, follow_redirect: follow_redirect)
        puts resp.inspect
        transform_response(resp)
      end

      def post_json(uri, query: nil, body: nil, header: nil, follow_redirect: nil)
        body = Oj.dump(body) unless body.nil?
        post(uri, query: query, body: body, header: header, follow_redirect: follow_redirect)
      end

      private

      def transform_response(resp)
        if resp.status_code == 401
          raise XBLAuthError
        end
        HttpResponse.new(resp.body, resp.headers, 200)
      end

      def transform_response_json(resp)
        if resp.status_code == 401
          raise XBLAuthError
        end
        HttpResponse.new(Oj.load(resp.body), resp.headers, 200)
      end
    end
  end

  class XBLAuthError < StandardError
  end

end


