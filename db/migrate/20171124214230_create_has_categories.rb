class CreateHasCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :has_categories do |t|
      t.references :article, foreign_key: true
      t.references :category

      t.timestamps
    end
  end
end
