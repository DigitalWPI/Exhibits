module ApplicationHelper
  include SpotlightHelper
  def render_thumbnail(document, options)
    image_tag(
      "https://digital.wpi.edu/downloads/#{document.id}?file=thumbnail", options)
  end
end
