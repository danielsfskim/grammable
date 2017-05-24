require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#update action" do
    it "should allow user to successfully update grams" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      patch :update, params: { id: gram.id, gram: { message: 'Changed' } }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "Changed"
    end

    it "should have http 404 error if the gram cannot be found" do
      patch :update, params: { id: "YOLOSWAG", gram: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      patch :update, params: { id: gram.id, gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Initial Value"
    end
  end


  describe "grams#edit action" do
    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      get :edit, params: { id: 'SWAG' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
    get :show, params: { id: 'TACOCAT' }
    expect(response). to have_http_status(:not_found)
    end
  end


  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


describe "grams#new action" do
  it "should require users to be logged in" do
    get :new
    expect(response).to redirect_to new_user_session_path
  end

  it "should successfully show the new form" do
   user = FactoryGirl.create(:user)
    sign_in user

    get :new
    expect(response).to have_http_status(:success)
  end
end

describe "grams#create action" do

  it "should require users to be logged in" do
    post :create, params: { gram: { message: "Hello" } }
    expect(response).to redirect_to new_user_session_path
  end

  it "should successfully create a new gram in our database" do
    user = FactoryGirl.create(:user)
      sign_in user

    post :create, params: { gram: { message: 'Hello!' } }
    expect(response).to redirect_to root_path

    gram = Gram.last
    expect(gram.message).to eq("Hello!")
    expect(gram.user).to eq(user)
  end

  it "should properly deal with validation errors" do
    user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user

    gram_count = Gram.count
    post :create, params: { gram: { message: '' } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(Gram.count).to eq 0
  end

 end
end 