module ApplicationHelper
  def digital_wpi_link(value:, **)
    return value unless Array(value)&.first.present?
    link_url = "#{ENV['HYRAX_HOST_URL']}/show/#{Array(value).first}"
    link_to "Click to view record", link_url, target:"_blank"
  end

  def manifest_url(document)
    model_name = @document[:has_model_ssim].first.underscore.pluralize
    "#{ENV.fetch('HYRAX_HOST_URL')}/concern/#{model_name}/#{@document.id}/manifest"
  end

  def pdfviewer_url(file_set)
    "#{ENV.fetch('HYRAX_HOST_URL')}/pdfviewer/#{file_set.id}"
  end

  def catalog_thumbnail_url(f_set)
     "#{ENV.fetch('HYRAX_HOST_URL')}#{thumbnail_url(f_set)}"
  end
end
