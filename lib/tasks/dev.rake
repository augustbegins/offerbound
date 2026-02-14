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
      job_app_seed_data = [
        {
          company_name: "Microsoft",
          job_title: "Software Engineer I",
          job_description: "This Software Engineer I position is designed for early-career engineers looking to build real-world experience. You will assist in implementing new features, fixing bugs, and improving existing systems. The team values collaboration, clear documentation, and thoughtful problem-solving. Prior internship, apprenticeship, or project experience is strongly encouraged.",
          touchpoints: [
            {
              short_description: "Sent introductory LinkedIn message to an engineer.",
              notes: "Messaged a current Microsoft engineer on LinkedIn to ask about their experience on the team and the interview process. We discussed the tech stack and how junior engineers ramp up during their first few months. They encouraged me to apply and offered to share my resume internally.",
            },
            {
              short_description: "Tailored resume and application materials.",
              notes: "Reviewed the job description carefully and updated my resume to emphasize backend APIs and cloud-related projects. Drafted responses to the application questions and made sure my portfolio links were up to date. Planning to submit after one final review.",
            },
            {
              short_description: "Submitted application through company portal.",
              notes: "Completed and submitted the application through the BMO careers portal. Double-checked resume formatting and confirmed all required documents were included. Logged the submission date for future follow-up.",
            },
          ],
        },

        {
          company_name: "LinkedIn",
          job_title: "Associate Software Engineer",
          job_description: "As an Associate Software Engineer, you will help develop and support features used by millions of users. You will work with modern web technologies while learning best practices in scalable system design. The role includes mentorship, code reviews, and close collaboration with cross-functional teams.",
          touchpoints: [
            {
              short_description: "Had Zoom coffee chat with current employee.",
              notes: "Scheduled a 30-minute Zoom coffee chat with a LinkedIn engineer who joined through an early-career program. We talked about interview preparation, team culture, and what projects helped them stand out. They recommended focusing on data structures and clear communication during interviews.",
            },
            {
              short_description: "Followed up with recruiter via email.",
              notes: "Sent a polite follow-up email to the recruiter confirming receipt of my application. Included a brief summary of my background and reiterated interest in the associate role. Waiting to hear back and tracking the follow-up date.",
            },
            {
              short_description: "Submitted application through company portal.",
              notes: "Completed and submitted the application through the LinkeIn careers portal. Double-checked resume formatting and confirmed all required documents were included. Logged the submission date for future follow-up.",
            },
          ],
        },

        {
          company_name: "BMO",
          job_title: "Junior Software Engineer",
          job_description: "The Junior Software Engineer will support internal platforms used across the organization. You will contribute to backend services, fix bugs, and assist with feature development. The team emphasizes code quality, testing, and steady growth through mentorship.",
          touchpoints: [
            {
              short_description: "Researched team and engineering culture.",
              notes: "Reviewed BMO’s technology blog and internal engineering initiatives to better understand the team’s focus. Took notes on the tools and languages mentioned in the posting. Used this information to adjust my resume and talking points.",
            },
            {
              short_description: "Submitted application through company portal.",
              notes: "Completed and submitted the application through the BMO careers portal. Double-checked resume formatting and confirmed all required documents were included. Logged the submission date for future follow-up.",
            },
            {
              short_description: "Had Zoom coffee chat with current employee.",
              notes: "Scheduled a 30-minute Zoom coffee chat with a BMO engineer who joined through an early-career program. We talked about interview preparation, team culture, and what projects helped them stand out. They recommended focusing on data structures and clear communication during interviews.",
            },
          ],
        },

        {
          company_name: "Shopify",
          job_title: "Backend Engineer – Entry Level",
          job_description: "This entry-level Backend Engineer role focuses on building and maintaining APIs that power core commerce features. You will collaborate with frontend engineers and product partners to deliver reliable solutions. The team values readable code, strong fundamentals, and continuous learning.",
          touchpoints: [
            {
              short_description: "Updated portfolio for backend focus.",
              notes: "Refactored my portfolio to highlight backend-heavy projects and API design work. Added clearer explanations of system architecture and tradeoffs. This was done specifically to better align with Shopify’s backend expectations.",
            },
            {
              short_description: "Submitted application through company portal.",
              notes: "Completed and submitted the application through the Shopify careers portal. Double-checked resume formatting and confirmed all required documents were included. Logged the submission date for future follow-up.",
            },
            {
              short_description: "Had Zoom coffee chat with current employee.",
              notes: "Scheduled a 30-minute Zoom coffee chat with a Shopify engineer who joined through an early-career program. We talked about interview preparation, team culture, and what projects helped them stand out. They recommended focusing on data structures and clear communication during interviews.",
            },
          ],
        },
      ]

      names.each do |name|
        user = User.find_or_create_by(email: "#{name}@example.com") do |u|
          puts "-- Adding user: #{u.email} --"
          u.password = "password"
          u.username = "#{name}_#{rand(10)}"
        end
      end
      puts "-- Finished adding users --"

      puts "-- Adding job applications --"

      50.times do
        name = names.sample
        email = "#{name}@example.com"
        user = User.find_by(email: email)

        seed = job_app_seed_data.sample
        
        next if JobApplication.exists?(
          user: user,
          company_name: seed[:company_name],
          job_title: seed[:job_title],
        )

        job_app = JobApplication.create(
          user: user,
          company_name: seed[:company_name],
          job_title: seed[:job_title],
          due_date: Faker::Date.forward(days: 23),
          job_description: seed[:job_description],
          status: ["planning", "applied", "interviewing", "offered", "rejected"].sample,
        )
        puts "-- Added job application for #{user.email} at #{job_app.company_name} --"

        seed[:touchpoints].shuffle.take(3).each do |tp_seed|
          touchpoint = Touchpoint.create(
            job_application_id: job_app.id,
            occurred_at: Faker::Date.between(from: 12.days.ago, to: Date.today),
            category: ["inbound_email", "outreach", "interview", "reflection", "other"].sample,
            notes: tp_seed[:notes],
            short_description: tp_seed[:short_description],
          )
          puts "-- Added touchpoints for #{user.email} at #{job_app.company_name} --"
        end
      end
      puts "-- Finished adding sample data --- "
    end
  end
end
