module TimeHelper
  def time_ago(time)
    "#{time_ago_in_words(time)} #{t('ago')}"
  end
end