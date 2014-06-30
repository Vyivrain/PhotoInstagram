class MyPhoto < ActiveRecord::Base

	def self.search( tag )
		
		if tag
			Instagram.tag_recent_media( tag )
		else
			[]
		end
	end

end
