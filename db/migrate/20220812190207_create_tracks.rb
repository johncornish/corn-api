class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :path
      t.boolean :played
      t.text :note
      t.integer :playlist_id

      t.timestamps
    end
  end
end
