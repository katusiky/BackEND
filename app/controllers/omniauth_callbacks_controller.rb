class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		auth = request.env["omniauth.auth"]
		data = {
			name: auth.info.name,
			email: auth.info.email,
			provider: auth.provider,
			uid: auth.uid
		}

		user = User.find_or_create_by_omniauth(data)

		if user.persisted?
			sign_in_and_redirect user_c, event: :authentication
		else
			session[:omniauth_errors]= user.errors.full_messages.to_sentence unless user.save
			
			session[:omniauth_data] = data

			redirect_to new_user_registration_url
		end
	end

	def twitter
		auth = request.env["omniauth.auth"]
		puts auth.info.nickname
		raise auth.to_json
		data = {
			name: auth.info.name,
			username: auth.info.nickname,
			email: "",
			provider: auth.provider,
			uid: auth.uid
		}

		user = User.find_or_create_by_omniauth(data)

		if user.persisted?
			sign_in_and_redirect user_c, event: :authentication
		else
			session[:omniauth_errors]= user.errors.full_messages.to_sentence unless user.save
			
			session[:omniauth_data] = data

			redirect_to new_user_registration_url
		end
	end
end