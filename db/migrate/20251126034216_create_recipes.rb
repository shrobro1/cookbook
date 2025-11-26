class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :description
      t.string :ingredients
      t.string :instructions
      t.integer :servings
      t.integer :creator_id
      t.string :source_url

      t.timestamps
    end
  end
end
