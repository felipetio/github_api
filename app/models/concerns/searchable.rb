module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search(search_params)
      results = self.where(nil)
      if search_params[:eq]
        search_params[:eq].each do |key, value|
          results = results.where(key => value) if value.present?
        end
      end

      results = results.order_by(search_params[:sort]) if search_params[:sort]

      results = results.limit(search_params[:limit]) if search_params[:limit]

      results = results.offset(search_params[:offset]) if search_params[:offset]

      results
    end
  end
end