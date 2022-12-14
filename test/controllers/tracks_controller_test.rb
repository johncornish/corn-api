require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @playlist = playlists(:one)
    @track = tracks(:one)
  end

  test "should get index" do
    get tracks_url, as: :json
    assert_response :success
  end

  test "should create track" do
    assert_difference('Track.count') do
      post tracks_url, params: { track: { note: @track.note, path: @track.path, played: @track.played, playlist_id: @playlist.id } }, as: :json
    end

    assert_response 201
  end

  test "should show track" do
    get track_url(@track), as: :json
    assert_response :success
  end

  test "should update track" do
    patch track_url(@track), params: { track: { note: @track.note, path: @track.path, played: @track.played, playlist_id: @playlist.id } }, as: :json
    assert_response 200
  end

  test "should destroy track" do
    assert_difference('Track.count', -1) do
      delete track_url(@track), as: :json
    end

    assert_response 204
  end
end
