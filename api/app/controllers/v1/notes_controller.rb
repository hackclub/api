# frozen_string_literal: true

module V1
  class NotesController < ApiController
    include UserAuth

    before_action :find_application, only: %i[index create]
    before_action :find_note, only: %i[show update destroy]
    before_action :authorize_note, only: %i[show update destroy]

    def index
      authorize @app.notes

      render_success @app.notes
    end

    def create
      note = @app.notes.new(user: current_user, body: params[:body])
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

    def find_application
      @app = NewClubApplication.find(params[:new_club_application_id])
    end

    def find_note
      @note = Note.find(params[:id])
    end

    def authorize_note
      authorize @note
    end
  end
end
