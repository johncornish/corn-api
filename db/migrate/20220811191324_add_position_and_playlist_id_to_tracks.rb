class AddPositionAndPlaylistIdToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :position, :integer
    add_column :tracks, :playlist_id, :integer
  end
end
