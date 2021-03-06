module Frontend::SeoHelper
  def init_seo(model)
    @_seo_info = model.the_seo
  end

  # add seo attributes to your page
  # you can pass custom data to overwrite default data generated by the system
  def the_seo(data = {})
    (@_seo_info ||= {}).merge(data)
  end

  # create seo attributes with options + default attributes
  def build_seo(options)
    options[:image] = options[:image] || current_site.get_option("screenshot", current_site.the_logo)
    options[:title] = I18n.transliterate(is_home? ? current_site.the_title : "#{current_site.the_title} | #{options[:title]}")
    options[:description] = I18n.transliterate(is_home? ? current_site.the_excerpt : options[:description])
    options[:keywords] = I18n.transliterate(is_home? ? current_site.get_option("keywords", "") : options[:keywords])
    options[:url] = request.original_url
    s = {:title => options[:title],
       :description => options[:description],
       :keywords => options[:keywords],
       :image => options[:image],
       :og => {
           :title    => options[:title],
           :description    => options[:description],
           :type     => 'website',
           :url      => request.original_url,
           :image    => options[:image]
       },
       :twitter => {
           :card => 'summary',
           :title    => options[:title],
           :description    => options[:description],
           :url      => request.original_url,
           :image    => options[:image],
           :site => "@wprails",
           :creator => "@wprails",
           :domain => request.host
       }
      }

    l = current_site.get_languages
    if l.size > 1
      s[:alternate] = {}
      l.each{|_l| s[:alternate][_l] = current_site.the_url(locale: _l) }
    end
    s
  end
end