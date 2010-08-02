module Picasa
  class Album
    attr_accessor :id, :title, :summary, :photos_count, :photo, :thumbnail, :google_user, :photos

    def self.parse_xml(google_user, xml_entry)
      album = new(google_user)
      album.id = xml_entry['id'][1]
      album.title = xml_entry['title'][0]['content']
      album.summary = if xml_entry['subtitle']
        xml_entry['subtitle'][0]['content']
      elsif xml_entry['summary']
        xml_entry['summary'][0]['content']
      end
      album.photos_count = xml_entry['numphotos'][0].to_i
      #has *group* when called from albums list
      if xml_entry['group']
        album.photo = xml_entry['group'][0]['content']['url']
        album.thumbnail = xml_entry['group'][0]['thumbnail'][0]['url']
      #has *entry* when called from find
      elsif xml_entry['entry']
        album.photos = xml_entry['entry'].map do |photo_xml_entry|
          Photo.parse_xml(photo_xml_entry)
        end
      end
      album
    end

    def self.all(google_user)
      data = Picasa::Connection.stablish("/data/feed/api/user/#{google_user}")
      xml = XmlSimple.xml_in(data)
      xml['entry'].map do |album_xml_entry|
        Picasa::Album.parse_xml(google_user, album_xml_entry)
      end if xml['entry']
    end

    def self.find(google_user, album_id)
      data = Picasa::Connection.stablish("/data/feed/api/user/#{google_user}/albumid/#{album_id}")
      xml = XmlSimple.xml_in(data)
      Album.parse_xml(google_user, xml)
    end

    def photos
      @photos ||= Photo.find_all_by_album_id(self.google_user, self.id)
    end

    def initialize(google_user)
      self.google_user = google_user
    end
  end
end
