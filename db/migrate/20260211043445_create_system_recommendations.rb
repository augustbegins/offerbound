class CreateSystemRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :system_recommendations do |t|
      t.integer :job_application_id
      t.string :recommendation_type
      t.text :message
      t.integer :status

      t.timestamps
    end
  end
end
