module Administrate
  module ApplicationHelper
    PLURAL_MANY_COUNT = 2.1

    def render_field(field, locals = {})
      locals.merge!(field: field)
      render locals: locals, partial: field.to_partial_path
    end

    def class_from_resource(resource_name)
      resource_name.to_s.classify.constantize
    end

    def display_resource_name(resource_name)
      class_from_resource(resource_name).
        model_name.
        human(
          count: PLURAL_MANY_COUNT,
          default: resource_name.to_s.pluralize.titleize,
        )
    end

    def sort_order(order)
      case order
      when "asc" then "ascending"
      when "desc" then "descending"
      else "none"
      end
    end

    SCOPES_LOCALE_SCOPE = [:administrate, :scopes].freeze
    # #translated_scope(key, resource_name): Retries the translation in the
    # root scope ('administrate.scopes') as fallback if translation for that
    # specific model doesn't exist. For example, calling *translated_scope
    # :active, :job_offer* with this yaml:
    #
    #   es:
    #     scopes:
    #       active: Activos
    #       job_offer:
    #         active: Activas
    #
    # ...will return "Activas", but calling *translated_scope :active, :job*
    # will return "Activos" since there's not specific translation for the
    # job model.
    # *NOTICE:* current code manages translation of a *scope_group* as if it
    # were another scope, and the translations of the default group name for
    # an array of scopes (*:scopes*) has been translated to do English (Filter)
    # and spanish (Filtros)... collaborations welcome!
    def translated_scope(key, resource_name)
      I18n.t key,
             scope: SCOPES_LOCALE_SCOPE + [resource_name],
             default: I18n.t(key, scope: SCOPES_LOCALE_SCOPE)
    end

    def resource_index_route_key(resource_name)
      ActiveModel::Naming.route_key(class_from_resource(resource_name))
    end

    def sanitized_order_params(page, current_field_name)
      collection_names = page.association_includes + [current_field_name]
      association_params = collection_names.map do |assoc_name|
        { assoc_name => %i[order direction page per_page] }
      end
      params.permit(:search, :id, :page, :per_page, association_params)
    end

    def clear_search_params
      params.except(:search, :page).permit(
        :per_page, resource_name => %i[order direction]
      )
    end
  end
end
