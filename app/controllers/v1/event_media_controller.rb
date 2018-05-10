# frozen_string_literal: true

module V1
  class EventMediaController < ApiController
    include UserAuth

    before_action :ensure_admin
    before_action :find_event

    def index
      render_success @event.photos
    end

    def create
      media_id = params[:media_id]
      return render_field_error(:media_id, 'required') unless media_id

      media = Attachment.find(media_id)

      if media.class == EventPhoto
        @event.photos << media
      elsif true == false # reserving this condition for later
      else
        return render_field_error(:media_id, 'invalid media type')
      end

      render_success(success: true)
    end

    def destroy
      @event.photos.delete(params[:id])

      render_success(success: true)
    end

    private

    def ensure_admin
      render_access_denied unless current_user.admin?
    end

    def find_event
      @event = Event.find(params[:event_id])
    end
  end
end
