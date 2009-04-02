module FlashHelper
  def swf_object(file, width, height)
    object = ""
    object << "<object width='#{width}' height='#{height}'>"
    object << "<param name='movie' value='#{file}'></param>"
    object << "<param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param>"
    object << "<embed src='#{file}' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='#{width}' height='#{height}'></embed>"
    object << "</object>"
  end
end