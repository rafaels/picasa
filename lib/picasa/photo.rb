module Picasa
  class Photo
    attr_accessor :title, :thumbnail_1, :thumbnail_2, :thumbnail_3, :keywords, :src

    def self.find_all_by_album_id(google_user, album_id)
      data = Picasa::Connection.stablish("/data/feed/api/user/#{google_user}/albumid/#{album_id}")
      Photo.parse_all_xml(data)
    end

    def self.find_all_by_tags(google_user, tags)
      data = Picasa::Connection.stablish("/data/feed/api/user/#{google_user}/?kind=photo&tag=#{tags}")
      Photo.parse_all_xml(data)
    end

    def self.parse_xml(xml_entry)
      photo = new
      photo.title = xml_entry['group'][0]['description'][0]['content']
      photo.thumbnail_1 = xml_entry['group'][0]['thumbnail'][0]['url']
      photo.thumbnail_2 = xml_entry['group'][0]['thumbnail'][1]['url']
      photo.thumbnail_3 = xml_entry['group'][0]['thumbnail'][2]['url']
      photo.keywords = xml_entry['group'][0]['keywords'][0]
      photo.src = xml_entry['content']['src']
      photo
    end

    def self.parse_all_xml(xml_data)
      xml = XmlSimple.xml_in(xml_data)
      xml['entry'].map do |photo_xml_entry|
        Photo.parse_xml(photo_xml_entry)
      end if xml['entry']
    end
  end
end
