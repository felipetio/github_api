module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search(search_params)
      results = self.where(nil)
      if search_params[:eq]
        search_params[:eq].each do |key, value|
          results = results.where(key.to_sym => value) if value.present?
        end
      end

      if search_params[:gt]
        search_params[:gt].each do |key, value|
          results = results.where(key.to_sym.gt => value) if value.present?
        end
      end

      if search_params[:gte]
        search_params[:gte].each do |key, value|
          results = results.where(key.to_sym.gte => value) if value.present?
        end
      end

      if search_params[:lt]
        search_params[:lt].each do |key, value|
          results = results.where(key.to_sym.lt => value) if value.present?
        end
      end

      if search_params[:lte]
        search_params[:lte].each do |key, value|
          results = results.where(key.to_sym.lte => value) if value.present?
        end
      end

      results = results.order_by(search_params[:sort]) if search_params[:sort]

      results = results.limit(search_params[:limit]) if search_params[:limit]

      results = results.offset(search_params[:offset]) if search_params[:offset]

      results
    end
  end
end