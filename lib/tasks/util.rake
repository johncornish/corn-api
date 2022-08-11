namespace :util do
  desc "Create Fake Playlists and Corresponding Tracks"
  task create_fake_data: :environment do
    playlist1 = Playlist.new(
      title: 'Fake playlist 1',
      description: 'Fake playlist description 1'
    )
    playlist2 = Playlist.new(
      title: 'Fake playlist 2',
      description: 'Fake playlist description 2'
    )

    track1 = Track.new(played: true, path: 'data/corn brain/06-01-22--05-10pm last responsible moment.wav', note: '')
    track2 = Track.new(played: false, path: 'data/corn brain/19 Psalms/Psalm 117 praise the Lord.wav', note: '')
    track3 = Track.new(played: false, path: '', note: 'Fake note 1')
    track4 = Track.new(played: false, path: 'data/corn brain/06-08-22--05-32pm no I did not manually delete.wav', note: '')
    track5 = Track.new(played: false, path: '', note: 'Fake note 2')

    playlist1.save
    playlist2.save

    track1.playlist_id = playlist1.id
    track2.playlist_id = playlist2.id
    track3.playlist_id = playlist1.id
    track4.playlist_id = playlist2.id
    track5.playlist_id = playlist2.id

    track1.save
    track2.save
    track3.save
    track4.save
    track5.save
  end
end
