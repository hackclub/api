class MassPmer
  def initialize(access_token, usernames = [])
    @access_token = access_token
    @usernames = usernames
  end

  def send_msg(text)
    @usernames.each do |username|
      user = user_from_username(username)
      next if user.nil?

      im = SlackClient::Chat.open_im(user[:id], @access_token)

      msg(im[:channel][:id], text)

      yield username
    end
  end

  private

  def msg(channel, text)
    SlackClient::Chat.send_msg(
      channel,
      text,
      @access_token,
      as_user: true
    )
  end

  def user_from_username(username)
    @all_users ||= SlackClient::Users.list(@access_token)[:members]

    @all_users.find { |u| u[:name] == username }
  end
end

desc 'Send a mass PM to usernames passed in STDIN'
task :mass_pm, [:api_token, :msg] => :environment do |_t, args|
  usernames = STDIN.read.split("\n")
  pmer = MassPmer.new(args[:api_token], usernames)

  pmer.send_msg(args[:msg]) do |username|
    puts "Messaged #{username}!"
  end
end
