module ApplicationHelper
  def digital_wpi_link(value:, **)
    link_url = "#{ENV['HYRAX_HOST_URL']}/show/#{value}"
    link_to "Click to view record", link_url, target:"_blank"
  end
end
