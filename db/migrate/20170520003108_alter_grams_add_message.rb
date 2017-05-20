class AlterGramsAddMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :grams, :message, :text
  end
end
