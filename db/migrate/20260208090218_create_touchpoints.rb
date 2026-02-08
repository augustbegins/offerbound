class CreateTouchpoints < ActiveRecord::Migration[8.0]
  def change
    create_table :touchpoints do |t|
      t.integer :job_application_id
      t.date :occurred_at
      t.string :category
      t.text :notes
      t.string :short_description

      t.timestamps
    end
  end
end
