require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object/blank"

module Administrate
  class Search
    def initialize(resolver, term)
      @resolver = resolver
      @term = term
    end

    def run
      if @term.blank?
        resource_class.all
      elsif (@scope = search_scope)
        resource_class.send @scope
      else
        resource_class.where(query, *search_terms)
      end
    end

    def search_scope
      if (@term[-1, 1] == ":")
        possible_scope = @term[0..-2]
        possible_scope if resource_class.respond_to?(possible_scope)
      end
    end

    private

    delegate :resource_class, to: :resolver

    def query
      search_attributes.map { |attr| "lower(#{attr}) LIKE ?" }.join(" OR ")
    end

    def search_terms
      ["%#{term.downcase}%"] * search_attributes.count
    end

    def search_attributes
      attribute_types.keys.select do |attribute|
        attribute_types[attribute].searchable?
      end
    end

    def attribute_types
      resolver.dashboard_class::ATTRIBUTE_TYPES
    end

    attr_reader :resolver, :term
  end
end
