module Cloud9Client
  module Project
    class << self
      def all(username)
        Cloud9Client.request(:get, "/users/#{username}/projects")
      end
    end
  end
end
