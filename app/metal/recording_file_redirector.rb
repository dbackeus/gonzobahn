# NOTE: Doesn't seem to work in Phusion Passenger so falls back on redirect_to in controller action

# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

# GET /recordings/id/file
# Responds with a 303 to the actual recording file
class RecordingFileRedirector
  def self.call(env)
    path = env["PATH_INFO"]
    if false #path =~ /^\/recordings\/.[0-9]\/file/
      id = path.split("\/")[-2]
      recording = Recording.find(id)
      
      [303, { "Content-Type" => "text/html", "Content-Length" => "0", 
      "Location" => "http://#{SITE_HOST}/system/recordings/#{id}/#{recording.filename}" }, []]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
