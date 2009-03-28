# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def title_for(object, prefix)
    "#{t(prefix)} #{object.class.human_name}"
  end
  
  def translate_and_join(*keys)
    keys.collect { |key| translate(key) }.join(" ")
  end
  alias :tj :translate_and_join
  
end
