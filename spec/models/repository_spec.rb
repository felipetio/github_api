require 'rails_helper'

RSpec.describe Repository, type: :model do
  it "should create an object with any column and search by it" do
    column_name = SecureRandom.urlsafe_base64(5)

    10.times { Repository.create(column_name => true) }
    10.times { Repository.create() }

    expect(Repository.count).to eq(20)
    expect(Repository.where(column_name=>true).count).to eq(10)
  end

  it "should not duplicate a entry with same id" do
    repo_params = lambda {{
      id: 1,
      name: SecureRandom.urlsafe_base64(5)
    }}

    expect(Repository.create(repo_params.call)).to be_truthy 
    expect{Repository.create(repo_params.call)}.to raise_error(Mongo::Error::OperationFailure)
  end
end
