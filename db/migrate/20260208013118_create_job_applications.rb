class CreateJobApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :job_applications do |t|
      t.string :company_name
      t.string :job_title
      t.integer :user_id
      t.text :job_description
      t.integer :status
      t.date :due_date
      t.integer :interviews_count

      t.timestamps
    end
  end
end
