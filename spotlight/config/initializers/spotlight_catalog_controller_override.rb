Rails.application.config.after_initialize do
  Rails.configuration.to_prepare do
    Spotlight::CatalogController.class_eval do
      before_action :set_universal_viewer, only: :show

      def set_universal_viewer
        configure_blacklight do |config|
          config.show.partials.insert(1, :universal_viewer)
        end
      end
    end
  end
end