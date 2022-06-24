Blacklight::DocumentPresenter.class_eval do
  self.thumbnail_presenter = ThumbnailPresenter
end
if ENV['THUMBNAIL_URL_PREFIX'].present?
  Rails.application.config.thumbnail_url_prefix = ENV['THUMBNAIL_URL_PREFIX']
else
  Rails.application.config.thumbnail_url_prefix = ''
end

