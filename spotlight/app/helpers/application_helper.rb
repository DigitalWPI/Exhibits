module ApplicationHelper
  def digital_wpi_link(value:, **)
    return value unless Array(value)&.first.present?
    link_url = "#{ENV['HYRAX_HOST_URL']}/show/#{Array(value).first}"
    link_to "Click to view record", link_url, target:"_blank"
  end
end
