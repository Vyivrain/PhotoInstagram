class PhotoController < ApplicationController
	
	def new
		@tag = "kittens"
		@result = Instagram.tag_recent_media( @tag )
	end
end
