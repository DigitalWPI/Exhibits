class ThumbnailPresenter < ::Blacklight::ThumbnailPresenter
  def thumbnail_value(image_options)
    puts 'In thumbnail_value'
    value = if thumbnail_method
              view_context.send(thumbnail_method, document, image_options)
            elsif thumbnail_field
              image_url = thumbnail_value_from_document
              if image_url.start_with?('/downloads')
                image_url = Rails.application.config.thumbnail_url_prefix + image_url
              end
              view_context.image_tag image_url, image_options if image_url.present?
            end
    puts value
    value || default_thumbnail_value(image_options)
  end
end
