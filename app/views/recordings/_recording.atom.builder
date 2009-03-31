feed.entry(recording) do |entry|
  entry.title recording.title
  entry.content "<img src=\"http://#{request.host_with_port+recording.thumbnail_path}\" alt=\"\"></img><p>#{recording.description}</p>", :type => 'html'
  
  entry.author do |author|
    author.name recording.user.login
    author.uri user_recordings_url(recording.user)
  end
end