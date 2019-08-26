module SearchableParams
  extend ActiveSupport::Concern

  def search_params 
    params.permit(:offset, :limit, :sort, :eq)

    response = {}

    response[:offset] = params[:offset].to_i if params[:offset]

    response[:limit] = params[:limit].to_i if params[:limit]

    response[:sort] = normalize_sort_array(params[:sort]) if params[:sort]

    response[:eq] = normalize(params[:eq].permit!.to_h) if params[:eq]

    response
  end

  def normalize_sort_array(sort)
    sort.split(',').map(&:to_sym)
  end

  def normalize(hash)
    Hash[hash.map{|k,v| [k, normalize_value(v)] }]
  end

  def normalize_value(value)
    case (value)
    when 'true'
      true
    when 'false'
      false
    when 'null','nil'
      nil
    when /\A-?\d+\z/
      value.to_i
    when /\A-?\d+\.\d+\z/
      value.to_f
    else
      value
    end
  end
end
