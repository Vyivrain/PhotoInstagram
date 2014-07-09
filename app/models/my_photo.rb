class MyPhoto < ActiveRecord::Base

	def self.search( tag, tags, user_id, coords, check_in )
		
		if tag 
			tagArr = tag.split
			result = Array.new
			first = true

			tagArr.each {
				|oneTag|

				if user_id and is_number?( oneTag )

					if first
						result.concat( idSearch( oneTag ) )
						first = false
					else
						response = idSearch( oneTag )
						result = result & response 
					end 

				elsif coords and is_coord?( oneTag )

					if first
						result.concat( coordSearch( oneTag ) )
						first = false
					else
						response = coordSearch( oneTag )
						result = result & response
					end
				  	 
				elsif tags and oneTag.length <= 10

					if first
						result.concat( tagsearch( oneTag ) ) 
						first = false
					else
						response = tagsearch( oneTag )
						result = result & response
					end
					
				elsif check_in and oneTag.length >= 20

					if first
						result.concat( checkinSearch( oneTag ) )
						first = false
					else
						response = checkinSearch( oneTag )
						result = result & response
					end
					
				else
					[]
				end
			}

			result.each {
				|element|

			}

			result
		else
			[]
		end

	end

	def self.tagsearch( tag )
		
		 JSON.parse( Instagram.tag_recent_media( tag ).to_json )

	end

	def self.idSearch( user_id )

		JSON.parse( Instagram.user_recent_media( user_id ).to_json )

	end

	def self.is_number?(str)
    	return true if str =~ /^\d+$/
    	true if Float(str) rescue false
    end
	  
	def self.is_coord?(str)

		if str.include? ","
			arr = str.split(",")

			if arr.length != 2
				return false
			end

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

	def self.coordSearch( coords )

		ll = coords.split(",")

		response = JSON.parse( Instagram.location_search( ll[0], ll[1] ).to_json )

		arr = Array.new

		response.each {
			|element|

			arr.push( element["id"] )
		}

		photourl = Array.new

		arr.each {
			|element|

			photourl.push( JSON.parse( Instagram.location_recent_media( element ).to_json ) )
		}
		
		arrConf = Array.new

		photourl.each {
			|x|

			if x[0].is_a?( Hash )
				arrConf.push( x[0] )
			end
		}

		arrConf
	end

	def self.checkinSearch( tag )

		initializeClient

		response = JSON.parse( @client.checkin( tag ).to_json )

		coords = response["venue"]["location"]["lat"].to_s + "," + response["venue"]["location"]["lng"].to_s

		coordSearch( coords )

	end

end
