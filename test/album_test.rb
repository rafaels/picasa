require "test_helper"

class AlbumTest < Test::Unit::TestCase
  FakeWeb.register_uri(:get, "picasaweb.google.com/data/feed/api/user/some.user", :response => fixture_file("albums"))
  FakeWeb.register_uri(:get, "picasaweb.google.com/data/feed/api/user/some.user/albumid/5500679996869508145", :response => fixture_file("first_album"))
  FakeWeb.register_uri(:get, "picasaweb.google.com/data/feed/api/user/some.user/albumid/5500678977826487201", :response => fixture_file("second_album"))

  test "Should return all albums" do
    albums = Picasa::Album.all("some.user")

    assert_equal 2, albums.count
    assert_equal "Copa", albums.first.title
    assert_equal 1, albums[1].photos_count
    assert_equal "5500679996869508145", albums.first.id
    assert_equal "http://lh6.ggpht.com/_dWuTCTElt7M/TFZWYvDOe6E/AAAAAAAAABI/i6nzid5qDaw/Povo.jpg", albums[1].photo
    assert_equal "Jogos da copa na casa de Ítalo!", albums.first.summary
    assert_equal "http://lh6.ggpht.com/_dWuTCTElt7M/TFZWYvDOe6E/AAAAAAAAABI/i6nzid5qDaw/s160-c/Povo.jpg", albums[1].thumbnail
    assert_equal "some.user", albums.first.google_user
  end

  test "Should find an album with user and id" do
    album = Picasa::Album.find("some.user", "5500679996869508145")

    assert_equal "5500679996869508145", album.id
    assert_equal "Copa", album.title
    assert_equal 1, album.photos_count
    assert_equal "Jogos da copa na casa de Ítalo!", album.summary
    assert_equal "some.user", album.google_user
  end

  test "Should find all photos" do
    photo = Picasa::Album.all("some.user")[1].photos.first

    assert_equal "Luisa", photo.title

    src = "http://lh6.ggpht.com/_dWuTCTElt7M/TFZWdxf0nSI/AAAAAAAAAA8/kcmV4QBFitM/DSC08628.jpg"
    assert_equal src, photo.src

    assert_equal "Praia, Povo", photo.keywords

    assert_not_nil photo.thumbnail_1
    assert_not_nil photo.thumbnail_2
    assert_not_nil photo.thumbnail_3
  end
end

