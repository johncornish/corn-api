class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.integer :visible_tracks
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
