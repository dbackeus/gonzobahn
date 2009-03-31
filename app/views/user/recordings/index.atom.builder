atom_feed :url => recordings_url(:format => :atom) do |feed|
  feed.title "#{t("site_name")} - #{t(".title", :user => user.to_s)}"
  feed.updated Time.now.utc
  
  feed.author do |author|
    author.name user.login
    author.uri user_recordings_url(user)
  end
  
  render :partial => "recordings/recording", :collection => @recordings, :locals => { :feed => feed }
end