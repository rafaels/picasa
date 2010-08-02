require 'rubygems'
gem 'test-unit'
require 'test/unit'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'picasa'

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

FakeWeb.register_uri(:get, "picasaweb.google.com/data/feed/api/user/some.user", :response => fixture_file("albums"))
FakeWeb.register_uri(:get, "picasaweb.google.com/data/feed/api/user/some.user/albumid/5500679996869508145", :response => fixture_file("first_album"))
FakeWeb.register_uri(:get, "picasaweb.google.com/data/feed/api/user/some.user/albumid/5500678977826487201", :response => fixture_file("second_album"))
FakeWeb.register_uri(:get, "picasaweb.google.com/data/feed/api/user/some.user?kind=photo&tag=Praia,Povo", :response => fixture_file("photos_by_tags"))

