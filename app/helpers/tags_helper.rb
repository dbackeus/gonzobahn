module TagsHelper
  # def tag_cloud(tags, classes)
  #   max_count = tags.sort_by(&:count).last.count.to_f
  #   
  #   tags.each do |tag|
  #     index = ((tag.count / max_count) * (classes.size - 1)).round
  #     yield tag, classes[index]
  #   end
  # end
  
  def tag_cloud(tags)
    tags.collect do |tag|
      link_to_function tag, "addTag('#{tag.to_s}')"
    end.join(" ")
  end
  
  def linked_tag_list(tags)
    tags.collect { |tag| link_to tag, recordings_path(:tag => tag.to_s) }.join(" ")
  end
end