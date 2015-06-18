require 'dotenv'
Dotenv.load

require 'rubygems'
require 'grape'
require 'sinatra/activerecord'
require 'httparty'
require 'json'

require_relative '../models/all'

module CYOA
	class API < Grape::API
		version 'v0.1', using: :path
		format :json

		helpers do
			def authorised?(fb_user_id, fb_access_token)
				# # Verify user
				# response = HTTParty.get("https://graph.facebook.com/me", :query => { :access_token => fb_access_token })
				# json = JSON.parse(response.body)
				# return false if json['data']['user_id'] != fb_user_id
				# # Verify access to application
				# response = HTTParty.get("https://graph.facebook.com/app", :query => { :access_token => fb_access_token })
				# json = JSON.parse(response.body)
				# return false if json['data']['app_id'] != {INSERT fb_app_id HERE}
				true
			end
		end

		resource :auth do
			params do
				requires :fb_user_id, type: Integer, desc: "User's unique Facebook user id."
				requires :fb_access_token, type: String, desc: "Valid Facebook access token."

				optional :first_name, type: String, desc: "User's first name."
				optional :last_name, type: String, desc: "User's last name."
				optional :email, type: String, desc: "User's email."
			end

			desc "Authenticate a user by using a Facebook access token"
			post do
				error!("Access denied.", 401) unless authorised?(params['fb_user_id'], params['fb_access_token'])
				begin
					User.find_by!(fb_user_id: params['fb_user_id'])
					status 200
				rescue ActiveRecord::RecordNotFound
					user = User.new(
						:fb_user_id => params['fb_user_id'],
						:first_name => params['first_name'],
						:last_name => params['last_name'],
						:email => params['email']
					)
					error!("Could not create user.", 400) unless user.valid?
					user.save
					status 201
				end
			end
		end

		resource :characters do
			helpers do
				def character_exists?(character_id)
					begin
						Character.find_by!(id: params['character_id'])
						true
					rescue ActiveRecord::RecordNotFound
						false
					end
				end

				def character_unlocked?(character_id)
					begin
						UserCharacter.where(fb_user_id: params['fb_user_id']).find_by!(character_id: params['character_id'])
						true
					rescue ActiveRecord::RecordNotFound
						false
					end
				end
			end

			params do
				requires :fb_user_id, type: Integer, desc: "User's unique Facebook user id."
				requires :fb_access_token, type: String, desc: "Valid Facebook access token."
			end

			desc "Return information of all characters available to the user"
			get do
				error!("Access denied.", 401) unless authorised?(params['fb_user_id'], params['fb_access_token'])
				status 200
				Character.joins("LEFT OUTER JOIN user_characters ON characters.id = user_characters.character_id").where("user_characters.fb_user_id = ?", params['fb_user_id']).as_json
			end

			desc "Return information for a single character available to the user"
			params do
				requires :character_id, type: Integer, desc: "Unique character id."
			end
			route_param :character_id do
				get do
					error!("Access denied.", 401) unless authorised?(params['fb_user_id'], params['fb_access_token'])
					error!("Character does not exist.", 400) unless character_exists?(params['character_id'])
					error!("Character is not available to user.", 403) unless character_unlocked?(params['character_id'])
					status 200
					Character.find_by!(id: params['character_id'])
				end
			end

			desc "Return saved progress for a single character available to the user"
			params do
				requires :character_id, type: Integer, desc: "Unique character id."
			end
			route_param :character_id do
				get 'progress' do
					error!("Access denied.", 401) unless authorised?(params['fb_user_id'], params['fb_access_token'])
					error!("Character does not exist.", 400) unless character_exists?(params['character_id'])
					error!("Character is not available to user.", 403) unless character_unlocked?(params['character_id'])
					status 200
					Message.joins("LEFT OUTER JOIN user_messages ON messages.id = user_messages.message_id").where("user_messages.fb_user_id = ?", params['fb_user_id']).as_json
				end
			end
		end
	end
end