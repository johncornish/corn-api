require 'test_helper'

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @playlist = playlists(:one)

    @track_1 = Track.new(path: 'existing track path 1', played: false, note: 'existing track note 1', playlist_id: @playlist.id)
    @track_1.save
    @track_2 = Track.new(path: 'existing track path 2', played: false, note: 'existing track note 2', playlist_id: @playlist.id)
    @track_2.save

    @new_track = Track.new(path: 'new track path', played: false, note: 'new track note')
  end

  test "should get index" do
    get playlists_url, as: :json
    assert_response :success
  end

  test "should create playlist" do
    assert_difference('Playlist.count') do
      post playlists_url, params: { playlist: { description: @playlist.description, title: @playlist.title, visible_tracks: @playlist.visible_tracks } }, as: :json
    end

    assert_response 201
  end

  test "should show playlist" do
    get playlist_url(@playlist), as: :json
    assert_response :success
  end

  test "should show playlist with tracks" do
    get playlist_url(@playlist), as: :json
    parsed_response = @response.parsed_body
    assert_equal @track_1.id, parsed_response['tracks'][0]['id']
    assert_equal @track_1.path, parsed_response['tracks'][0]['path']
    assert_equal @track_1.played, parsed_response['tracks'][0]['played']
    assert_equal @track_1.note, parsed_response['tracks'][0]['note']
    assert_equal @playlist.id, parsed_response['tracks'][0]['playlist_id']

    assert_equal @playlist.id, parsed_response['tracks'][1]['playlist_id']
  end

  test "should update playlist" do
    patch playlist_url(@playlist), params: { playlist: { description: @playlist.description, title: @playlist.title, visible_tracks: @playlist.visible_tracks } }, as: :json
    assert_response 200
  end

  # test "should not update playlist's tracks when tracks are not provided" do
  #   patch playlist_url(@playlist), params: { playlist: { description: @playlist.description, title: @playlist.title, visible_tracks: @playlist.visible_tracks } }, as: :json
  #   assert_response 200
  #
  #   parsed_response = @response.parsed_body
  #   assert_equal @playlist.id, parsed_response['tracks'][0].playlist_id
  #   assert_equal @playlist.id, parsed_response['tracks'][1].playlist_id
  # end

  test "should update playlist's tracks when tracks are provided" do
    @track_2.path = 'updated path 2'
    @track_2.played = true
    @track_2.note = 'updated note 2'

    patch playlist_url(@playlist), params: { playlist: { description: @playlist.description, title: @playlist.title, visible_tracks: @playlist.visible_tracks, tracks_attributes: [@track_1, @track_2] } }, as: :json
    assert_response 200

    parsed_response = @response.parsed_body
    assert_equal @track_1.id, parsed_response['tracks'][0]['id']
    assert_equal 'existing track path 1', parsed_response['tracks'][0]['path']
    assert_equal false, parsed_response['tracks'][0]['played']
    assert_equal 'existing track note 1', parsed_response['tracks'][0]['note']
    assert_equal @playlist.id, parsed_response['tracks'][0]['playlist_id']

    assert_equal @track_2.id, parsed_response['tracks'][1]['id']
    assert_equal 'updated path 2', parsed_response['tracks'][1]['path']
    assert_equal true, parsed_response['tracks'][1]['played']
    assert_equal 'updated note 2', parsed_response['tracks'][1]['note']
    assert_equal @playlist.id, parsed_response['tracks'][1]['playlist_id']

    # assert_not_nil parsed_response['tracks'][2]['id']
    # assert_equal 'new track path', parsed_response['tracks'][2]['path']
    # assert_equal true, parsed_response['tracks'][2]['played']
    # assert_equal 'new track note', parsed_response['tracks'][2]['note']
    # assert_equal @playlist.id, parsed_response['tracks'][2]['playlist_id']
  end

  test "should drop and create new tracks within playlist" do
    @track_2.path = 'updated path 2'
    @track_2.played = true
    @track_2.note = 'updated note 2'

    assert_nil @new_track.id

    patch playlist_url(@playlist), params: { playlist: { description: @playlist.description, title: @playlist.title, visible_tracks: @playlist.visible_tracks, tracks_attributes: [@track_1, @track_2, @new_track] } }, as: :json
    assert_response 200

    parsed_response = @response.parsed_body

    # I guess we'll delete tracks another way
    assert_equal 3, parsed_response['tracks'].length

    assert_equal @track_1.id, parsed_response['tracks'][0]['id']

    assert_equal @track_2.id, parsed_response['tracks'][1]['id']
    assert_equal 'updated path 2', parsed_response['tracks'][1]['path']
    assert_equal true, parsed_response['tracks'][1]['played']
    assert_equal 'updated note 2', parsed_response['tracks'][1]['note']
    assert_equal @playlist.id, parsed_response['tracks'][1]['playlist_id']

    assert_not_nil parsed_response['tracks'][2]['id']
    assert_equal 'new track path', parsed_response['tracks'][2]['path']
    assert_equal false, parsed_response['tracks'][2]['played']
    assert_equal 'new track note', parsed_response['tracks'][2]['note']
    assert_equal @playlist.id, parsed_response['tracks'][2]['playlist_id']
  end

  test "should destroy playlist" do
    assert_difference('Playlist.count', -1) do
      delete playlist_url(@playlist), as: :json
    end

    assert_response 204
  end
end
