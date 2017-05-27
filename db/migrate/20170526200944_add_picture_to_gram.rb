class AddPictureToGram < ActiveRecord::Migration[5.0]
  def change
    add_column :grams, :picture, :string
  end
end
