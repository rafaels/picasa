module Picasa
  module Connection
    def self.stablish(url)
      full_url = "http://picasaweb.google.com" + url
      Net::HTTP.get(URI.parse(full_url))
    end
  end
end

