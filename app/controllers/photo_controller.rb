class PhotoController < ApplicationController
	
	def index
		@photo = MyPhoto.search( params[:tag], params[:tags], params[:user_id], 
			params[:coords], params[:check_in] )
	end

	def new
		@photo = MyPhoto.new
	end

	def create
	end
end
