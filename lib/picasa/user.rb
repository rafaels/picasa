module Picasa
  class User
    def initialize(google_user)
      raise ArgumentError.new("You must specify a google user") unless google_user
      @google_user = google_user
    end

    def albums
      @albums ||= Picasa::Album.all(@google_user)
    end

    def photos(options = {})
      raise ArgumentError.new("You must specify album_id") unless options[:album_id]
      Picasa::Photo.find_all_by_album_id(@google_user, options[:album_id])
    end

    def photos_by_tags(tags)
      Picasa::Photo.find_all_by_tags(@google_user, tags)
    end
  end
end
