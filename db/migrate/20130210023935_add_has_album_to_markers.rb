class AddHasAlbumToMarkers < ActiveRecord::Migration
  def change
    add_column :markers, :has_album, :boolean, :default => false
  end
end
