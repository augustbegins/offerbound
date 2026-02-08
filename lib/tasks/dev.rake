puts "Loading dev sample_data task..."
unless Rails.env.production?
  namespace :dev do
    desc "Add sample data"
    task sample_data: :environment do
      puts "-- Clearing existing data --"

      # Delete all existing records
      Touchpoint.destroy_all
      JobApplication.destroy_all
      User.destroy_all

      puts "-- Adding sample data --"

      puts "-- Adding admin user --"

      User.find_or_create_by!(email: "admin@example.com") do |u|
        u.password = "supersecurepassword"
        u.role = :admin
      end

      puts "-- Added admin user --"

      puts "-- Adding users --"

      names = [
        "aaliyah",
        "benett",
        "cassius",
        "devon",
        "estefani",
        "fabio",
        "gina",
      ]

      names.each do |name|
        user = User.find_or_create_by(email: "#{name}@example.com") do |u|
          puts "-- Adding user: #{u.email} --"
          u.password = "password"
          u.username = "#{name}_#{rand(10)}"
        end
      end
      puts "-- Finished adding users --"

      puts "-- Adding job applicatons --"

      20.times do
        name = names.sample
        email = "#{name}@example.com"
        user = User.find_by(email: email)

        job_app = JobApplication.create(
          user: user,
          company_name: Faker::Company.name,
          job_title: Faker::Company.profession,
          due_date: Faker::Date.forward(days: 23),
          job_description: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
          status: ["planning", "applied", "interviewing", "offered", "rejected"].sample,
        )
        puts "-- Added job application for #{user.email} at #{job_app.company_name} --"

        10.times do
          touchpoint = Touchpoint.create(
            job_application_id: job_app.id,
            occurred_at: Faker::Date.between(from: 12.days.ago, to: Date.today),
            category: ["inbound_email", "outreach", "interview", "reflection", "other"].sample,
            notes: Faker::TvShows::MichaelScott.quote,
            short_description: Faker::TvShows::Spongebob.quote,
          )
          puts "-- Added touchpoints for #{user.email} at #{job_app.company_name} --"
        end
      end
      puts "-- Finished adding sample data --- "
    end
  end
end
