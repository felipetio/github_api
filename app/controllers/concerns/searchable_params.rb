module SearchableParams
  extend ActiveSupport::Concern

  def search_params 
    q = params[:q].permit! if params[:q]
    Hash[q.to_h.map{|k,v| [k, normalize(v)] }]
  end

  def normalize(value)
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
