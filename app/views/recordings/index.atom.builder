atom_feed :url => recordings_url(:format => :atom) do |feed|
  feed.title t(".title")
  feed.updated Time.now.utc
  
  feed.author do |author|
    author.name "Gonzobahn"
    author.uri "http://gonzobahn.mine.nu"
  end
  
  for recording in @recordings
    feed.entry(recording) do |entry|
      entry.title recording.title
      entry.content "<img src=\"http://#{request.host_with_port+recording.thumbnail_path}\" alt=\"\"></img><p>#{recording.description}</p>", :type => 'html'
      
      entry.author do |author|
        author.name recording.user.login
        author.uri user_recordings_url(recording.user)
      end
    end
  end
end