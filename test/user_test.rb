require "test_helper"

class UserTest < Test::Unit::TestCase
  test "Should return all albums" do
    user = Picasa::User.new("some.user")
    albums = user.albums

    assert_equal 2, albums.count
    assert_equal "Copa", albums.first.title
    assert_equal 1, albums[1].photos_count
    assert_equal "5500679996869508145", albums.first.id
    assert_equal "http://lh6.ggpht.com/_dWuTCTElt7M/TFZWYvDOe6E/AAAAAAAAABI/i6nzid5qDaw/Povo.jpg", albums[1].photo
    assert_equal "Jogos da copa na casa de Ítalo!", albums.first.summary
    assert_equal "http://lh6.ggpht.com/_dWuTCTElt7M/TFZWYvDOe6E/AAAAAAAAABI/i6nzid5qDaw/s160-c/Povo.jpg", albums[1].thumbnail
    assert_equal "some.user", albums.first.google_user
  end

  test "Should find photos" do
    user = Picasa::User.new("some.user")
    photo = user.albums[1].photos.first

    assert_equal "Luisa", photo.title

    src = "http://lh6.ggpht.com/_dWuTCTElt7M/TFZWdxf0nSI/AAAAAAAAAA8/kcmV4QBFitM/DSC08628.jpg"
    assert_equal src, photo.src

    assert_equal "Praia, Povo", photo.tags

    assert_not_nil photo.thumbnail_1
    assert_not_nil photo.thumbnail_2
    assert_not_nil photo.thumbnail_3
  end

  test "Should find photos by tag" do
    user = Picasa::User.new("some.user")

    photos = user.photos_by_tags('Praia, Povo')

    assert_equal 2, photos.size
    assert_match "Praia", photos[0].tags
    assert_match "Praia", photos[1].tags
    assert_match "Povo", photos[0].tags
    assert_match "Povo", photos[1].tags
  end
end

