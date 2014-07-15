class PhotoController < ApplicationController
	
	def index

		@radioButName ||= { 
			tags: "Tags search" ,
			user_id_tag: "User id and tag search" ,
		    coords_user: "Coordinate and user search",
		    coords_tag: "Coordinate and tag search", 
		    check_in_tag: "Check-in tag search",
		    check_in_user: "Check-in user search",
		    check_in_tag_user: "Check-in, tag and user search"
		}

		 searchManage

	end

	def new
		@photo = MyPhoto.new
	end

	def create
	end

	def searchManage

		case params[:check_tag]
		when "tags"
			@photo = MyPhoto.tagsearch( params[:tag] )
		when "user_id_tag"
			@photo = MyPhoto.id_tag_Search( params[:tag] )
		when "coords_user"
			@photo = MyPhoto.coord_user_Search( params[:tag], true )
		when "coords_tag"
			@photo = MyPhoto.coord_user_Search( params[:tag], false )
		when "check_in_tag"
			@photo = MyPhoto.check_in_tag_Search( params[:tag], false )
		when "check_in_user"
			@photo = MyPhoto.check_in_tag_Search( params[:tag], true )
		when "check_in_tag_user"
			@photo = MyPhoto.check_in_tag_user_id_Search( params[:tag] )
		end

	end

	
  	
end
