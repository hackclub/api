# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::ChallengePostComments', type: :request do
  # override in subtests
  let(:method) { :post }
  let(:url) { '' }
  let(:headers) { {} }
  let(:params) { {} }

  let(:user) { {} } # override in subtests
  let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

  # put anything that needs to happen before the request in an override of this
  let(:setup) { {} }

  before do
    # run any needed setup
    setup

    # make http request
    send(method, url, headers: headers, params: params)
  end

  let(:cpost) { create(:challenge_post) }

  describe 'POST /v1/posts/:id/comments' do
    let(:method) { :post }
    let(:url) { "/v1/posts/#{cpost.id}/comments" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'gracefully fails without valid params' do
        expect(response.status).to eq(422)
        expect(json['errors']['body']).to include("can't be blank")
      end

      context 'with valid params' do
        # bare minimum
        let(:params) do
          {
            user_id: user.id,
            challenge_post_id: cpost.id,
            body: 'Test!'
          }
        end

        it 'successfully creates' do
          expect(response.status).to eq(201)
        end

        context 'and a parent comment' do
          let(:parent) do
            create(:challenge_post_comment, challenge_post: cpost)
          end

          let(:setup) do
            params[:parent_id] = parent.id
          end

          it 'successfully creates' do
            expect(response.status).to eq(201)

            expect(ChallengePostComment.last.parent).to eq(parent)
          end
        end
      end
    end
  end

  describe 'GET /v1/posts/:id/comments' do
    let(:method) { :get }
    let(:url) { "/v1/posts/#{cpost.id}/comments" }

    it 'successfully returns an empty array' do
      expect(response.status).to eq(200)
      expect(json.length).to eq(0)
    end

    context 'with root-level comments' do
      let(:setup) do
        5.times { create(:challenge_post_comment, challenge_post: cpost) }

        cpost2 = create(:challenge_post)
        2.times { create(:challenge_post_comment, challenge_post: cpost2) }
      end

      it 'returns commits from current challenge post' do
        expect(response.status).to eq(200)
        expect(json.length).to eq(5)
      end

      context 'with child comments' do
        let(:setup) do
          comment = create(:challenge_post_comment, challenge_post: cpost)

          child1 = create(
            :challenge_post_comment,
            challenge_post: cpost,
            parent: comment
          )
          _child2 = create(
            :challenge_post_comment,
            challenge_post: cpost,
            parent: comment
          )

          _subchild1 = create(
            :challenge_post_comment,
            challenge_post: cpost,
            parent: child1
          )
        end

        it 'nests child comments' do
          expect(response.status).to eq(200)
          expect(json.length).to eq(1)

          expect(json[0]['children'].length).to eq(2)
          expect(json[0]['children'][0]['children'].length).to eq(1)
          expect(json[0]['children'][1]['children'].length).to eq(0)
        end
      end
    end
  end

  describe 'PATCH /v1/post_comments/:id' do
    let(:comment) { create(:challenge_post_comment, challenge_post: cpost) }

    let(:method) { :patch }
    let(:url) { "/v1/post_comments/#{comment.id}" }

    let(:params) do
      {
        "body": 'New body!'
      }
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires you to be the comment creator' do
        expect(response.status).to eq(403)
      end

      context 'as creator' do
        let(:comment) do
          create(
            :challenge_post_comment,
            challenge_post: cpost,
            user: user
          )
        end

        it 'succeeds' do
          expect(response.status).to eq(200)
          expect(json['body']).to eq('New body!')
        end

        context 'with invalid params' do
          let(:params) do
            {
              body: nil
            }
          end

          it 'gracefully fails' do
            expect(response.status).to eq(422)
            expect(json['errors']).to include('body')
          end
        end
      end
    end
  end

  describe 'DELETE /v1/post_comments/:id' do
    let(:comment) { create(:challenge_post_comment, challenge_post: cpost) }

    let(:method) { :delete }
    let(:url) { "/v1/post_comments/#{comment.id}" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires you to be the comment creator' do
        expect(response.status).to eq(403)
      end

      context 'as comment creator' do
        let(:comment) do
          create(
            :challenge_post_comment,
            challenge_post: cpost,
            user: user
          )
        end

        it 'succeeds' do
          expect(response.status).to eq(200)
          expect(ChallengePostComment.find_by(id: comment.id)).to eq(nil)
        end
      end
    end
  end
end
