class AdministratorSessionController < ApplicationController

	def new
	end

	def create
		user = login(params[:email], params[:password])
		if user 
			if user.role == "admin"
				redirect_to admin_profile_path
			else
				flash.now[:danger] = "Esta cuenta no es de administrador"
				redirect_to root_path
			end
		else
			flash.now[:danger] = 'Invalid email/password combination'
			render 'new'
		end
	end
end
