class CreateMyPhotos < ActiveRecord::Migration
  def change
    create_table :my_photos do |t|

      t.timestamps
    end
  end
end
