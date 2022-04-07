# frozen_string_literal: true

##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog

  def self.uploaded_field
    'system_create_dtsi'
  end

  def self.modified_field
    'system_modified_dtsi'
  end

  configure_blacklight do |config|
          config.show.oembed_field = :oembed_url_ssm
          config.show.partials.insert(1, :oembed)

    config.view.gallery.document_component = Blacklight::Gallery::DocumentComponent
    # config.view.gallery.classes = 'row-cols-2 row-cols-md-3'
    config.view.masonry.document_component = Blacklight::Gallery::DocumentComponent
    config.view.slideshow.document_component = Blacklight::Gallery::SlideshowComponent
    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      fl: '*'
    }

    config.document_solr_path = 'get'
    config.document_unique_id_param = 'ids'

    # solr field configuration for search results/index views
    config.index.title_field = "title_tesim"
    config.index.display_type_field = "has_model_ssim"
    config.index.thumbnail_field = 'thumbnail_path_ss'

    config.add_field_configuration_to_solr_request!

    # enable facets:
    # https://github.com/projectblacklight/spotlight/issues/1812#issuecomment-327345318
    config.add_facet_fields_to_solr_request!

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    config.add_facet_field "human_readable_type_tesim", label: "Type", limit: 5
    config.add_facet_field "year_tesim", label: "Year", limit: 5, sort: 'index desc'
    config.add_facet_field "creator_tesim", label: "Creator", limit: 5, sort: 'index', index_range: 'A'..'Z'
    config.add_facet_field "advisor_tesim", label: "Advisor", limit: 5, sort: 'index', index_range: 'A'..'Z'
    config.add_facet_field "contributor_tesim", label: "Contributor", limit: 5, sort: 'index', index_range: 'A'..'Z'
    config.add_facet_field "center_tesim", label: "Project Center", limit: 5, sort: 'index', index_range: 'A'..'Z'
    config.add_facet_field "major_tesim", label: "Major", limit: 5, sort: 'index', index_range: 'A'..'Z'
    config.add_facet_field "department_tesim", label: "Unit", limit: 5, sort: 'index', index_range: 'A'..'Z'
    config.add_facet_field "publisher_tesim", label: "Publisher", limit: 5
    config.add_facet_field "subject_tesim", label: "Subject", limit: 5, sort: 'index', index_range: 'A'..'Z'
    config.add_facet_field "resource_type_tesim", label: "Resource Type", limit: 5
    #config.add_facet_field "language_tesim", limit: 5
    # The generic_type isn't displayed on the facet list
    # It's used to give a label to the filter that comes from the user profile
    # config.add_facet_field solr_name("generic_type", :facetable), if: false

    # # solr fields to be displayed in the index (search results) view
    # #   The ordering of the field names is the order of the display
    # config.add_index_field "title_tesim", label: "Title", itemprop: 'name', if: false
    # # config.add_index_field description_tesim, itemprop: 'description', helper_method: :iconify_auto_link
    # config.add_index_field "keyword_tesim", itemprop: 'keywords', link_to_search: solr_name("keyword", :facetable)
    # # config.add_index_field "subject_tesim", itemprop: 'about', link_to_search: solr_name("subject", :facetable)
    # config.add_index_field "creator_tesim", itemprop: 'creator', link_to_search: "creator_tesim"
    # #config.add_index_field solr_name("contributor", :stored_searchable), itemprop: 'contributor', link_to_search: "contributor_tesim"
    # config.add_index_field solr_name("advisor", :stored_searchable), label: "Advisor", itemprop: 'advisor', link_to_search: "advisor_tesim"
    # # config.add_index_field solr_name("proxy_depositor", :symbol), label: "Depositor", helper_method: :link_to_profile
    # # config.add_index_field solr_name("depositor"), label: "Owner", helper_method: :link_to_profile
    # config.add_index_field solr_name("publisher", :stored_searchable), itemprop: 'publisher', link_to_search: solr_name("publisher", :facetable)
    # # config.add_index_field solr_name("based_near_label", :stored_searchable), itemprop: 'contentLocation', link_to_search: solr_name("based_near_label", :facetable)
    # # config.add_index_field solr_name("language", :stored_searchable), itemprop: 'inLanguage', link_to_search: "language_tesim"
    # # config.add_index_field solr_name("date_uploaded", :stored_sortable, type: :date), itemprop: 'datePublished', helper_method: :human_readable_date
    # # config.add_index_field solr_name("date_modified", :stored_sortable, type: :date), itemprop: 'dateModified', helper_method: :human_readable_date
    # config.add_index_field solr_name("date_created", :stored_searchable), itemprop: 'dateCreated'
    # # config.add_index_field solr_name("rights_statement", :stored_searchable), helper_method: :rights_statement_links
    # # config.add_index_field solr_name("license", :stored_searchable), helper_method: :license_links
    # config.add_index_field solr_name("resource_type", :stored_searchable), label: "Resource Type", link_to_search: solr_name("resource_type", :facetable)
    # # config.add_index_field solr_name("file_format", :stored_searchable), link_to_search: solr_name("file_format", :facetable)
    # # config.add_index_field solr_name("identifier", :stored_searchable), helper_method: :index_field_link, field_name: 'identifier'
    # # config.add_index_field solr_name("embargo_release_date", :stored_sortable, type: :date), label: "Embargo release date", helper_method: :human_readable_date
    # # config.add_index_field solr_name("lease_expiration_date", :stored_sortable, type: :date), label: "Lease expiration date", helper_method: :human_readable_date
    # config.add_index_field solr_name("degree", :stored_searchable), label: "Degree"
    # config.add_index_field solr_name("department", :stored_searchable), label: "Unit"

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    # config.add_show_field "title_tesim"
    # config.add_show_field "description_tesim"
    # config.add_show_field "keyword_tesim"
    # config.add_show_field "creator_tesim"
    # config.add_show_field solr_name("contributor", :stored_searchable)
    # config.add_show_field solr_name("publisher", :stored_searchable)
    # config.add_show_field solr_name("date_created", :stored_searchable)
    # config.add_show_field solr_name("degree", :stored_searchable), label: "Degree"
    # config.add_show_field solr_name("department", :stored_searchable), label: "Unit"
    # config.add_show_field solr_name("format", :stored_searchable)
    # config.add_show_field solr_name("identifier", :stored_searchable)
    # config.add_show_field "subject_tesim"
    # config.add_show_field solr_name("based_near_label", :stored_searchable)
    # config.add_show_field solr_name("language", :stored_searchable)
    # config.add_show_field solr_name("date_uploaded", :stored_searchable)
    # config.add_show_field solr_name("date_modified", :stored_searchable)
    # config.add_show_field solr_name("rights_statement", :stored_searchable)
    # config.add_show_field solr_name("license", :stored_searchable)
    # config.add_show_field solr_name("resource_type", :stored_searchable), label: "Resource Type"
    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.
    #
    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field('all_fields', label: I18n.t('spotlight.search.fields.search.all_fields')) do |field|
      all_names = config.show_fields.values.map(&:field).join(" ")
      title_name = "title_tesim"
      field.solr_parameters = {
        qf: "#{all_names} file_format_tesim all_text_timv",
        pf: title_name.to_s
      }
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.
    # creator, title, description, publisher, date_created,
    # subject, language, resource_type, format, identifier, based_near,
    config.add_search_field('contributor') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      solr_name = "contributor_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('creator') do |field|
      solr_name = "creator_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('title') do |field|
      solr_name = "title_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('description') do |field|
      field.label = "Abstract or Summary"
      solr_name = "description_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('publisher') do |field|
      solr_name = "publisher_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_created') do |field|
      solr_name = "created_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject') do |field|
      solr_name = "subject_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('language') do |field|
      solr_name = "language_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('resource_type') do |field|
      solr_name = "resource_type_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('format') do |field|
      solr_name = "format_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('identifier') do |field|
      solr_name = "id"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('based_near') do |field|
      field.label = "Location"
      solr_name = "based_near_label_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('keyword') do |field|
      solr_name = "keyword_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('depositor') do |field|
      solr_name = "depositor_ssim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('rights_statement') do |field|
      solr_name = "rights_statement_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('license') do |field|
      solr_name = "license_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('advisor') do |field|
      solr_name = "advisor_tesim"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # label is key, solr field is value
    config.add_sort_field 'relevance', sort: "score desc, #{uploaded_field} desc", label: I18n.t('spotlight.search.fields.sort.relevance')
    config.add_sort_field 'date_uploaded_desc', sort: "#{uploaded_field} desc", label: "date uploaded \u25BC"
    config.add_sort_field 'date_uploaded_asc', sort: "#{uploaded_field} asc", label: "date uploaded \u25B2"
    config.add_sort_field 'date_modified_desc', sort: "#{modified_field} desc", label: "date modified \u25BC"
    config.add_sort_field 'date_modified_asc', sort: "#{modified_field} asc", label: "date modified \u25B2"

    config.index.thumbnail_method = :render_thumbnail


    # Set which views by default only have the title displayed, e.g.,
    # config.view.gallery.title_only_by_default = true
  end
end
