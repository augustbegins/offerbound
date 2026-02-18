# OfferBound
A job search companion that tracks applications, interviews, and reflections and generates structured guidance to help junior Software Engineers improve with each iteration. OfferBound transforms the job search from a passive tracking exercise into an intentional feedback system.

## The "Why"
Most tools track applications, few help track the various outreach, research, and reflex through each application's life cycle. OfferBound introduces lightweight automation that evaluates activity and prompts better next steps — such as follow-ups, reflections, and preparation reminders.

## Core Capabilities 
- Job Application tracking with status management using enums
- Touchpoint logging (messaging, interviews, reflections)
- Rule-based, time-based, and status-based recommendations
- Scheduled evaluation via background jobs

## Tech Stack
- Ruby on Rails 8
- PostgreSQL/ActiveRecord
- Bootstrap
- Devise
- ActiveJob
- Deployed on Render

## Architecture Highlights
Built with intentional domain modeling and separation of concerns. Business logic is isolated from controllers to maintain clarity and scalability. Users can only access their own data to maintain security. 

### Core Relationships
- `User has_many :job_applications`
- `User has_many :system_recommendations`
- `JobApplication has_many :touch_points, belongs_to :user`
- `Touchpoint belongs_to :job_application`
- `SystemRecommendation belongs_to :user`
  
### Separation of Concerns 
- Query scopes manage filtering and authorization
- Service objects for recommendation logic
- ActiveJob for background processing
- Cron scheduling for time-based evaluations
- Enums for state transition

### Security & Data Integrity
- All queries are scoped to `current_user` preventing ID enumeration
- Controller-level ownership validation
- Strong parameters prevent mass assignment
- Devise-based authentication

## Stretch Goals
The architecture is intentionally designed to support these additions without major refactoring: 

### Storage 
- File storage (for resume upload)
- Audio Storage and transcriptions (for interview snippet uploads)
  
### AI Based Recommendations
- Reflection analysis
- Resume tailoring for each role
- Interview preparation prompts
- Interview reponse analysis

## Live Demo
*Coming soon (currently in active development and deployed on Render)*
