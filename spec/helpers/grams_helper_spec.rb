require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the GramsHelper. For example:
#
# describe GramsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe GramsHelper, type: :helper do
  describe "grams#index action" do
    if "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
