class FakeSlackEventService
  def initialize(team, user_id, channel_id = nil, type = 'message', message = nil)
    @team = team
    @team_id = team.team_id
    @bot_access_token = team.bot_access_token
    @user_id = user_id
    @channel_id = (channel_id.nil? ? im_id : channel_id)
    @type = type
    @message = message
  end

  def event
    {
      channel: @channel_id,
      message: @message,
      team_id: @team_id,
      ts: 'fake.timestamp',
      type: @type,
      user: @user_id
    }
  end

  private

  def im_id
    SlackClient::Chat.open_im(@user_id, @bot_access_token)[:channel][:id]
  end
end
