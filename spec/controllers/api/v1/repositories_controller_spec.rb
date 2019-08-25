require 'rails_helper'

RSpec.describe Api::V1::RepositoriesController, type: :controller do
  let(:valid_attributes) {
    { name: SecureRandom.urlsafe_base64(5) }
  }

  # this should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # api::v1::repositoryscontroller. be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "get #index" do
    it "returns a success response" do
      10.times { Repository.create! valid_attributes }
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "get #show" do
    it "returns a success response" do
      repository = Repository.create! valid_attributes.merge(id:1)
      get :show, params: {id: 1}, session: valid_session
      expect(response).to be_successful
    end
  end
end
