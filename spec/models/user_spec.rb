require 'rails_helper'

RSpec.describe User, type: :model do
  it "should create an object with any column and search by it" do
    column_name = SecureRandom.urlsafe_base64(5)

    10.times { User.create(column_name => true) }
    10.times { User.create() }

    expect(User.count).to eq(20)
    expect(User.where(column_name=>true).count).to eq(10)
  end

  it "should not duplicate a entry with same id" do
    user_params = lambda {{
      id: 1,
      login: SecureRandom.urlsafe_base64(5)
    }}

    expect(User.create(user_params.call)).to be_truthy 
    expect{User.create(user_params.call)}.to raise_error(Mongo::Error::OperationFailure)
  end
end 
