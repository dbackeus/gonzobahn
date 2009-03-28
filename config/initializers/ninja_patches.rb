class ActionView::Helpers::InstanceTag
  def to_label_tag_with_human_attribute(text = nil, options = {})
    if text.blank?
      text = @object.present? ? @object.class.human_attribute_name(method_name.to_s) : method_name.humanize
    end
    to_label_tag_without_human_attribute(text, options)
  end
  
  alias_method_chain :to_label_tag, :human_attribute
end