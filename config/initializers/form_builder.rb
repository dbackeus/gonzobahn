class LabelizedFormBuilder < ActionView::Helpers::FormBuilder
  def auto_completing_text_field(method, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    label = label(method, options[:label])
    field = @template.text_field_with_auto_complete(@object_name, method)
    @template.content_tag(:p, label +'<br/>' + field)
  end
  
  helpers = field_helpers +
            %w{text_field_with_auto_complete} +
            %w{date_select datetime_select time_select} +
            %w{collection_select select country_select time_zone_select} -
            %w{hidden_field label fields_for} # Don't decorate these

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      label = label(field, options[:label])
      @template.content_tag(:p, label +'<br/>' + super)
    end
  end
end

ActionView::Base.default_form_builder = LabelizedFormBuilder