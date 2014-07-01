class PhotoController < ApplicationController
	
	def index
		@photo = MyPhoto.search( params[:tag] )
	end

	def new
		@photo = MyPhoto.new
	end

	def create
	end
end
