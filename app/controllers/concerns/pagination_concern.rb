# frozen_string_literal: true

module Concerns
  module PaginationConcern
    extend ActiveSupport::Concern
    include Pagy::Backend

    def pagy_get_vars(collection, vars)
      vars[:count] ||= collection.size
      vars[:page]  ||= page_number
      vars[:items] ||= items_number
      vars
    end

    def paginate(scope)
      pagination, records = pagy(scope)

      records.instance_eval do
        @pagination = pagination

        def current_page
          @pagination.page
        end

        def next_page
          @pagination.next
        end

        def total_pages
          @pagination.pages
        end

        def size
          @pagination.items
        end
      end

      records
    end

    private

    def page_number
      params.dig(:page, :number) || 1
    end

    def items_number
      params.dig(:page, :size) || Pagy::VARS[:items]
    end
  end
end
