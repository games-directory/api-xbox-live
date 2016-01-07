class XboxLiveApi
  class SessionInfo
    require 'date'

    # @return [Fixnum] the xbox live id for the logged in user
    attr_reader :user_id
    # @return [String] the xbox live gamertag for the logged in user
    attr_reader :gamertag
    # @return [String] the xbox live token used to make requests for the logged in user
    attr_reader :token
    # @return [DateTime] the time of the token expiration
    attr_reader :expires

    def initialize(user_id: nil, gamertag: nil, token: nil, expires: nil)
      @user_id = user_id
      @gamertag = gamertag
      @token = token
      @expires = DateTime.parse(expires)
    end

    # @return [Boolean] true if session info will expire within 2 hours
    def expired?
      @expires < (DateTime.now + 2/24.0)
    end

    def ==(o)
      o.instance_of?(self.class) && o.state == state
    end

    def hash
      state.hash
    end

    protected

    def state
      [@user_id, @gamertag, @token]
    end
  end
end
