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

  describe "get #index" do
    it "returns only the matching items" do
      5.times { Repository.create! valid_attributes.merge(has_issues: true) }
      5.times { Repository.create! valid_attributes.merge(has_issues: false) }

      get :index, params: {eq: {has_issues: true}}, session: valid_session

      items = JSON.parse(response.body)
      expect(items.count).to eq(5)
    end
  end

  describe "get #index" do
    it "returns a limit number of itens" do
      10.times { Repository.create! valid_attributes }

      get :index, params: {limit: 5}, session: valid_session

      items = JSON.parse(response.body)
      expect(items.count).to eq(5)
    end
  end

  describe "get #index" do
    it "returns itens with a offset" do
      10.times { Repository.create! valid_attributes }

      get :index, params: {offset: 8}, session: valid_session

      items = JSON.parse(response.body)
      expect(items.count).to eq(2)
    end
  end

  describe "get #index" do
    before(:each) do
      2.times { Repository.create! valid_attributes.merge(forks: 0) }
      2.times { Repository.create! valid_attributes.merge(forks: 1) }
      2.times { Repository.create! valid_attributes.merge(forks: 2) }
      2.times { Repository.create! valid_attributes.merge(forks: 3) }
      2.times { Repository.create! valid_attributes.merge(forks: 4) }
    end

    it "returns itens respecting greater than search operator" do
      get :index, params: {gt: {forks: 1}}, session: valid_session

      items = JSON.parse(response.body)
      expect(items.count).to eq(6)
    end

    it "returns itens respecting greater or equal than search operator" do
      get :index, params: {gte: {forks: 1}}, session: valid_session

      items = JSON.parse(response.body)
      expect(items.count).to eq(8)
    end

    it "returns itens respecting lower than search operator" do
      get :index, params: {lt: {forks: 1}}, session: valid_session

      items = JSON.parse(response.body)
      expect(items.count).to eq(2)
    end

    it "returns itens respecting lower or equal than search operator" do
      get :index, params: {lte: {forks: 1}}, session: valid_session

      items = JSON.parse(response.body)
      expect(items.count).to eq(4)
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
