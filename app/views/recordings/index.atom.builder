atom_feed :url => recordings_url(:format => :atom) do |feed|
  feed.title "#{t("site_name")} - #{t(".title")}"
  feed.updated Time.now.utc
  
  feed.author do |author|
    author.name "Gonzobahn"
    author.uri "http://gonzobahn.mine.nu"
  end
  
  render :partial => @recordings, :locals => { :feed => feed }
end