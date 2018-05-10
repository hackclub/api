# frozen_string_literal: true

module V1
  # This controller is set up in a bit of a unique way. Since notes can be
  # created and listed at multiple routes, like so:
  #
  #   GET or POST /v1/new_club_applications/:id/notes
  #   GET or POST /v1/new_clubs/:id/notes
  #
  # we need to be able to work with multiple models, but reuse the same logic
  # across them. This controller achieves that through the find_model method,
  # which finds the appropriate model for the current route.
  class NotesController < ApiController
    include UserAuth

    before_action :find_model, only: %i[index create]
    before_action :find_note, only: %i[show update destroy]
    before_action :authorize_note, only: %i[show update destroy]

    def index
      authorize @model.notes

      render_success @model.notes
    end

    def create
      note = @model.notes.new(user: current_user, body: params[:body])
      authorize note

      if note.save
        render_success note, 201
      else
        render_field_errors note.errors
      end
    end

    def show
      render_success @note
    end

    def update
      if @note.update_attributes(body: params[:body])
        render_success @note
      else
        render_field_errors @note.errors
      end
    end

    def destroy
      @note.destroy
      render_success @note
    end

    private

    def find_model
      if params[:new_club_application_id]
        @model = NewClubApplication.find(params[:new_club_application_id])
      elsif params[:new_club_id]
        @model = NewClub.find(params[:new_club_id])
      end
    end

    def find_note
      @note = Note.find(params[:id])
    end

    def authorize_note
      authorize @note
    end
  end
end
