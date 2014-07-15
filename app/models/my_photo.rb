class MyPhoto < ActiveRecord::Base

	# Multiple tag example "cat kitten"
	# Max tags 2
	def self.tagsearch( tag )
		
		response = []

		tagArr = tag.split

		return [] if tagArr.length > 2

		tagArr.each {
			|oneTag|

			if response.empty?
				response = JSON.parse( Instagram.tag_recent_media( oneTag, { count: 50 } ).to_json )
			else
				response = response & JSON.parse( Instagram.tag_recent_media( oneTag, { count: 50 } ).to_json )
			end

		}

		response
 		
	end

	# User id and tag search
	# Example "1422420615 cat"
	def self.id_tag_Search( tag )

		response = []

		tagArr = tag.split

		if is_number?( tagArr[0] )

			result = JSON.parse( Instagram.user_recent_media( tagArr[0], { count: 50 } ).to_json )

			result.each {
				|x|

				response << x if x["tags"].include?( tagArr[1] )
			}


		end 

		response

	end

	def self.is_number?(str)
    	return true if str =~ /^\d+$/
    	true if Float(str) rescue false
    end
	  
	def self.is_coord?(str)

		if str.include? ","
			arr = str.split(",")

			return false if arr.length != 2

			check = true

			arr.each {
				|x|
				
				check = check and is_number?( x )
			}

			check
		else
			false
		end

	end

	def self.initializeClient

		@client ||= Foursquare2::Client.new( :client_id => 'YA4PUIA1ABAACRXXBBL5EWFFPNLTYRFRTJV3JA5RX5QR4JLG',
										     :client_secret => 'QYCR4NE3W0Z3RMRLY1WFHRZMFMRMPHJT44ACH5BUG5OQH2MO',
										     :oauth_token => 'MRL4KVA0BWWVVGUHLZHIOM3HLOFU2GJ3PA3M0N0T1FXRXVOT',
										     :api_version => '20140701' )
	end


	#Coordinates search with tags or user_id
	#search_id - true -> coords with user_id search
	#search_id - false -> coords with tag search
	#Example "34.071,-118.445 summer"
	def self.coord_user_Search( tag, search_id )

		tagArr = tag.split

		ll = tagArr[0].split( "," )

		response = JSON.parse( Instagram.location_search( ll[0], ll[1] ).to_json )

		photourl = []

		response.each {
			|element|

			arr = JSON.parse( Instagram.location_recent_media( element["id"], { count: 50 } ).to_json )

			arr.each {
				|e|
				
				photourl << e if search_id and e.is_a?( Hash ) and e["user"]["id"] == tagArr[1]

				photourl << e if !search_id and e.is_a?( Hash ) and e["tags"].include? tagArr[1]
			}	
		}

		puts photourl

		photourl
	end

	#Search by coords with user id and coords with tag
	#search_id - true -> coords with user_id search
	#search_id - false -> coords with tag search
	#Example "53c3800c498e0abe55f520f0 food"
	def self.check_in_tag_Search( tag, search_id )

		initializeClient

		tagArr = tag.split

		response = JSON.parse( @client.checkin( tagArr[0] ).to_json )

		coords = response["venue"]["location"]["lat"].to_s + "," + response["venue"]["location"]["lng"].to_s + " " + tagArr[1]

		coord_user_Search( coords, search_id )

	end

	#Search by coords with user id and with tag
	#Example "53c3800c498e0abe55f520f0 food 210579418"
	def self.check_in_tag_user_id_Search( tag )

		initializeClient

		tagArr = tag.split

		response = JSON.parse( @client.checkin( tagArr[0] ).to_json )				

		coords1 = response["venue"]["location"]["lat"].to_s + "," + response["venue"]["location"]["lng"].to_s + " " + tagArr[1]

		coords2 = response["venue"]["location"]["lat"].to_s + "," + response["venue"]["location"]["lng"].to_s + " " + tagArr[2]

		response = coord_user_Search( coords1, false ) & coord_user_Search( coords2, true )

	end

end
