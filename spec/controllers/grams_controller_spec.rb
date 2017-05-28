require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
  
    it "should successfully show the page" do
      get :index 
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "grams#new action" do
    it "should successfully show new form" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "grams#create action" do
     it "should require users to be logged in" do
      post :create, params: {gram: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully create a new gram in our database" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, params: { gram: {message: "Hello", image: fixture_file_upload('test.png', 'image/png')} }
      expect(response).to redirect_to root_path
      
      gram = Gram.last
      expect(gram.message).to eq("Hello")
      expect(gram.user).to eq(user)
    end
    
    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, params: { gram: {message: ""} }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end
  
  describe "grams#show action" do
    it "should successfully show the page details if gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end
    
    it "should show a 404 if gram not found" do
      get :show, params: { id: 'tacocat' }
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe "gram#edit action" do
    it "should not allow user who didn't create gram to edit it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, params: {id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end
    
    it "should not allow unauthorized users to edit gram" do
      gram = FactoryGirl.create(:gram)
      get :edit, params: {id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should succesfully show an edit form" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      get :edit, params: {id: gram.id }
      expect(response).to have_http_status(:success)
    end
  
    it "should show a 404 if gram not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, params: {id: 'tacocat' }
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe "gram#update action" do
    it "should not allow user who didn't create gram to update it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: {id: gram.id, gram: {message: "Initial message" } }
      expect(response).to have_http_status(:forbidden)
    end
    
    it "should not allow unauthorized users to update gram" do
      gram = FactoryGirl.create(:gram)
      patch :update, params: {id: gram.id, gram: {message: "Initial message"} }
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should successfully update gram" do
      gram = FactoryGirl.create(:gram, message: "Initial message")
      sign_in gram.user
      patch :update, params: {id: gram.id, gram: {message: "Changed" } }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "Changed"
    end
    
    it "should show a 404 page if gram not found on update" do
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: {id: 'swayzee', gram: {message: "Changed"} }
      expect(response).to have_http_status(:not_found)
    end
    
    it "should render edit form if with http status unprocessable_entity" do
      user = FactoryGirl.create(:user)
      sign_in user
      gram = FactoryGirl.create(:gram, message: "Initial message", user: user)
      patch :update, params: {id: gram.id, gram: {message: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Initial message"
    end
  end
    
    describe "gram#destroy action" do
    it "should not allow user who didn't create gram to destroy it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: {id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end
      
    it "should not allow unauthorized users to destroy gram" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, params: {id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should succesfully delete gram if gram found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      delete :destroy, params: {id: gram.id }
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end
    
    it "should show 404 if gram not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: {id: "ain't here" }
      expect(response).to have_http_status(:not_found)
    end
  end
end