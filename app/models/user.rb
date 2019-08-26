class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Searchable
end
