require 'rails_helper'

RSpec.describe GramsController, type: :controller do
#destroy
  describe "grams#destroy action" do
    it "shouldn't allow users who didn't create the gram to destroy it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGir.create(:user)
      sign_in user
      delete :destroy, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a gram" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy grams" do
      gram = FactoryGirl.create(:gram) #creates a new gram to TEST
      sign_in gram.user #ensure the user who created teh gram will be signed in
      delete :destroy, params: { id: gram.id } #action it will take once the gram id is found
      expect(response).to redirect_to root_path #next action after deletion
      gram = Gram.find_by_id(gram.id) #execute the find of the gram we want to delete
      expect(gram).to eq nil #nil expected to show once deletion is successful
    end

    it "should return a 404 message if we cannot find a gram with the id that is specified" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SPACEDUCK' }
      expect(response).to have_http_status(:not_found)
    end
  end
#update action
  describe "grams#update action" do
    it "shouldn't let users who didn't create the gram update it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: { id: gram.id, gram: { message: 'wahoo' } } #patch can be used to update partial resources
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users create a gram" do
      gram = FactoryGirl.create(:gram)
      patch :update, params: { id: gram.id, gram: { message: "Hello" } } 
      expect(response).to redirect_to_new_user_session_path
    end

    it "should allow user to successfully update grams" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in gram.user

      patch :update, params: { id: gram.id, gram: { message: 'Changed' } }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "Changed"
    end

    it "should have http 404 error if the gram cannot be found" do
      user = FactoryGirl.create(:user)
      sign_in user

      patch :update, params: { id: "YOLOSWAG", gram: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in gram.user

      patch :update, params: { id: gram.id, gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Initial Value"
    end
  end

#edit action
  describe "grams#edit action" do
    it "shouldn't let a user who did not create the gram edit a gram" do
      gram = FactoryGirl.create(:gram) #will create a gram, and also populate a user that is connected to the gram
      user = FactoryGirl.create(:user) #creates a new user in our database
      get :edit, params: { id: gram.id }  #triggers an HTTP GET request to edit action for the gram we created
      expect(response).to have_http_status(:forbidden)
      sign_in user
    end

    it "shouldn't let unauthenticated users edit a gram" do
      gram = FactoryGirl.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to redirect_to_new_user_session_path
    end

    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user

      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :edit, params: { id: 'SWAG' }
      expect(response).to have_http_status(:not_found)
    end
  end
#show action
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

#index action
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

#new action
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
#create action
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