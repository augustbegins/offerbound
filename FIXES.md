# Prioritized Improvement Plan — OfferBound

## P0 — Critical (Security / Architecture / Broken Patterns)

### P0-1: Zero Test Coverage

**File:** `spec/features/sample_spec.rb` and all of `spec/`

**Problem:** The only test in the project is:
```ruby
describe "This project" do
  it "is not graded" do
    expect(1).to eq(1)
  end
end
```
RSpec and Capybara are configured and installed but produce no real coverage. No model, controller, request, or feature specs exist.

**Suggested Solution:** Write tests covering at minimum:

1. Model validations:
```ruby
# spec/models/job_application_spec.rb
RSpec.describe JobApplication, type: :model do
  it { should validate_presence_of(:company_name) }
  it { should validate_presence_of(:job_title) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:due_date) }
  it { should validate_presence_of(:job_description) }
  it { should belong_to(:user) }
  it { should have_many(:touchpoints) }
  it { should have_many(:system_recommendations) }
end
```

2. Controller authorization:
```ruby
# spec/requests/job_applications_spec.rb
RSpec.describe "JobApplications", type: :request do
  it "redirects unauthenticated users" do
    get job_applications_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "prevents accessing another user's job application" do
    other_user = create(:user)
    job_app = create(:job_application, user: other_user)
    sign_in create(:user)
    get job_application_path(job_app)
    expect(response).to have_http_status(:not_found).or redirect_to(root_path)
  end
end
```

3. Service objects and background jobs.

---

### P0-2: Disabled CI/CD Pipeline

**File:** `.github/workflows/ci.yml`

**Problem:** All meaningful CI jobs are commented out. Only a placeholder job runs on every push, meaning broken code, security vulnerabilities, and style regressions are never automatically caught.

```yaml
# Everything here is commented out:
# scan_ruby:
# scan_js:
# lint:
# test:
```

**Suggested Solution:** Uncomment and restore all CI jobs. At minimum:

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - run: bundle exec rubocop

  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres
        env:
          POSTGRES_PASSWORD: password
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - run: bundle exec rails db:test:prepare
      - run: bundle exec rspec
```

---

### P0-3: Turbo Drive Configuration Conflict

**File:** `app/javascript/application.js`

**Problem:** Turbo Drive is enabled and then immediately disabled on the next line:
```javascript
Turbo.session.drive = true   // line N
Turbo.session.drive = false  // line N+1 — overrides the above
```
The second line makes the first a no-op. Turbo Drive is effectively disabled for the entire application, preventing page-transition optimization and Turbo Stream updates.

**Suggested Solution:** Decide on one behavior and remove the conflicting line:

```javascript
// Option A: Enable Turbo Drive (recommended for most Rails 8 apps)
Turbo.session.drive = true

// Option B: Disable it intentionally (if AJAX conflicts exist)
// Turbo.session.drive = false  // remove entirely, false is not the default
```

If Turbo Drive is intentionally disabled, remove both lines and document why.

---

### P0-4: Typo in Background Job Method Name

**File:** `app/jobs/job_application_follow_up_job.rb`, line 4

**Problem:** Method is defined as `peform` instead of `perform`. If this is not an explicit alias, the job will never execute its intended logic when called via `perform_later`.

**Suggested Solution:**
```ruby
# Before (likely wrong):
def peform(job_application_id)

# After:
def perform(job_application_id)
```

Verify by running the job manually in a Rails console and checking Solid Queue logs.

---

### P0-5: Missing README Setup Instructions

**File:** `README.md`

**Problem:** A new developer cannot run this project. No setup instructions exist. The project requires PostgreSQL, specific gems (Devise, Cloudinary, OpenAI), and environment variables that are undocumented.

**Suggested Solution:** Add a Setup section:

```markdown
## Setup

### Prerequisites
- Ruby 3.x
- PostgreSQL
- Node.js (for asset compilation)

### Installation

```bash
git clone <repo-url>
cd offerbound
bundle install
```

### Environment Variables

Copy `.env.example` to `.env` and fill in:

```
DATABASE_URL=postgresql://localhost/offerbound_development
OPENAI_API_KEY=your_key_here
CLOUDINARY_URL=cloudinary://...
ROLLBAR_ACCESS_TOKEN=your_token_here
```

### Database Setup

```bash
rails db:create db:migrate db:seed
```

### Run

```bash
bin/dev
```
```

Also create a `.env.example` file at the project root with all required variables (no values).

---

## P1 — Important (Maintainability / Convention / Cleanliness)

These are not blocking but significantly affect maintainability and professionalism.

---

### P1-1: Unused Gems Creating False Expectations

**File:** `Gemfile`

**Problem:** Several gems are installed but produce zero functionality:
- `ransack` — no search forms or `params[:q]` usage anywhere
- `kaminari` — no `.page(params[:page])` calls
- `pagy` — no `include Pagy::Backend` in controllers
- `carrierwave` — no `mount_uploader` on any model
- `cloudinary` — no image upload functionality

This is misleading and adds dependency bloat.

**Suggested Solution (choose one):**

A. Implement the features. For pagination:
```ruby
# app/controllers/job_applications_controller.rb
def index
  @pagy, @job_applications = pagy(job_application_scope, items: 10)
end
```
```erb
<%# app/views/job_applications/index.html.erb %>
<%== pagy_nav(@pagy) %>
```

B. Remove unused gems:
```ruby
# Remove from Gemfile:
gem "ransack"
gem "kaminari"
gem "pagy"
gem "carrierwave"
gem "cloudinary"
```

---

### P1-2: No AJAX CRUD Operations

**File:** All form views in `app/views/`

**Problem:** All forms perform full-page reloads. The rubric explicitly requires at least one AJAX CRUD action. Turbo Streams (already installed) would satisfy this cleanly.

**Suggested Solution:** Convert recommendation status updates to Turbo Stream:

```ruby
# app/controllers/system_recommendations_controller.rb
def update
  @system_recommendation = current_user.system_recommendations.find(params[:id])
  @system_recommendation.update(system_recommendation_params)
  respond_to do |format|
    format.turbo_stream { render turbo_stream: turbo_stream.remove(@system_recommendation) }
    format.html { redirect_to system_recommendations_path }
  end
end
```

```erb
<%# app/views/system_recommendations/_recommendation.html.erb %>
<%= turbo_frame_tag dom_id(recommendation) do %>
  <%# recommendation content %>
<% end %>
```

---

### P1-3: No Client-Side Form Validation

**File:** `app/views/job_applications/_form.html.erb`, `app/views/touchpoints/_form.html.erb`

**Problem:** Forms have no client-side validation. Users receive no feedback until after a server round-trip.

**Suggested Solution:** Add HTML5 validation attributes:

```erb
<%= f.text_field :company_name,
    class: "form-control",
    required: true,
    minlength: 2,
    maxlength: 100 %>

<%= f.date_field :due_date,
    class: "form-control",
    required: true %>
```

For richer UX, add a Stimulus validation controller:
```javascript
// app/javascript/controllers/form_validation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit"]

  validate(event) {
    const valid = this.element.checkValidity()
    this.submitTarget.disabled = !valid
    if (!valid) this.element.reportValidity()
  }
}
```

---

### P1-4: Admin Role Has No UI

**File:** `app/models/user.rb`, `config/routes.rb`

**Problem:** `User` model has `role` enum (`user: 0, admin: 1`) and `current_user.admin?` is checked in `ApplicationController`, but there is no admin interface, admin routes, or admin-specific views. The role system is incomplete.

**Suggested Solution:** Either implement a basic admin namespace or remove the admin role if it's unused:

```ruby
# config/routes.rb
namespace :admin do
  resources :users
  resources :job_applications, only: [:index, :show]
end
```

Or simplify the model if admin functionality is not needed:
```ruby
# app/models/user.rb — remove if unused:
# enum :role, { user: 0, admin: 1 }
```

---

### P1-5: Incomplete Accessibility

**File:** Multiple view files throughout `app/views/`

**Problem:** ARIA roles and alt text are inconsistently applied. Icon images lack meaningful alt descriptions. Dynamic content areas (recommendation list, flash messages) lack `aria-live` regions.

**Suggested Solution:**

```erb
<%# For icon images used as decorative elements %>
<%= image_tag "icon.svg", alt: "", role: "presentation" %>

<%# For meaningful images %>
<%= image_tag "preview.png", alt: "Screenshot of the OfferBound dashboard showing job application tracking" %>

<%# For dynamic flash area %>
<div aria-live="polite" aria-atomic="true">
  <%= render "shared/toasts" %>
</div>

<%# For form field descriptions %>
<%= f.text_area :job_description,
    "aria-describedby": "job-description-hint",
    class: "form-control" %>
<div id="job-description-hint" class="form-text">
  Paste the full job description to enable AI recommendations.
</div>
```

---

### P1-6: No Contribution Guidelines or Branch Strategy

**File:** `README.md`

**Problem:** No documented process for contributing, branching, or PR workflow. Entire commit history is on `main` with direct pushes.

**Suggested Solution:** Add to README:

```markdown
## Contributing

### Branch Naming
- Features: `feature/description-of-feature`
- Bugs: `fix/description-of-bug`
- Refactors: `refactor/description`

### Pull Request Process
1. Create a branch from `main`
2. Implement changes with focused commits
3. Open a PR referencing the related Issue
4. Request review before merging
5. Squash merge to keep `main` history clean

### Commit Messages
Use imperative mood: "Add job application form" not "Added job application form"
```

Enable branch protection on GitHub: Settings → Branches → Add rule → require PR reviews before merging.

---

### P1-7: Enable Email Notifications

**File:** `app/mailers/application_mailer.rb`

**Problem:** `ApplicationMailer` is a default stub with no mailers implemented. The background job pipeline generates recommendations asynchronously — users have no way to know new recommendations are available unless they manually check the app.

**Suggested Solution:** Create a recommendation notification mailer:

```ruby
# app/mailers/recommendation_mailer.rb
class RecommendationMailer < ApplicationMailer
  def new_recommendations(user)
    @user = user
    @recommendations = user.system_recommendations.pending.recent
    mail(to: @user.email, subject: "New job search recommendations for you")
  end
end
```

```erb
<%# app/views/recommendation_mailer/new_recommendations.html.erb %>
<h1>You have new recommendations</h1>
<% @recommendations.each do |rec| %>
  <p><%= rec.message %></p>
<% end %>
<%= link_to "View all recommendations", system_recommendations_url %>
```

Configure ActionMailer for production delivery (SendGrid, Postmark, etc.).

---

## P2 — Polish (UX / Enhancements)

These would meaningfully improve user experience and project completeness.

---

### P2-1: Implement Pagination

**File:** `app/controllers/system_recommendations_controller.rb`, `app/controllers/job_applications_controller.rb`

**Problem:** All records load without limit. As data grows, performance and UX degrade. Both `kaminari` and `pagy` are already installed.

**Suggested Solution:** Use Pagy (already in Gemfile):

```ruby
# app/controllers/application_controller.rb
include Pagy::Backend

# app/controllers/system_recommendations_controller.rb
def pending
  @pagy, @system_recommendations = pagy(
    current_user.system_recommendations.includes(:job_application).pending,
    items: 10
  )
end
```

```erb
<%# In views %>
<%== pagy_nav(@pagy) %>
```

---

### P2-2: Implement Search and Filtering

**File:** `app/controllers/job_applications_controller.rb`, `app/views/job_applications/index.html.erb`

**Problem:** `ransack` gem is installed but no search functionality exists. Users cannot filter or search job applications.

**Suggested Solution:**

```ruby
# app/controllers/job_applications_controller.rb
def index
  @q = job_application_scope.ransack(params[:q])
  @job_applications = @q.result(distinct: true)
end
```

```erb
<%# app/views/job_applications/index.html.erb %>
<%= search_form_for @q do |f| %>
  <%= f.search_field :company_name_cont,
      placeholder: "Search companies...",
      class: "form-control" %>
  <%= f.select :status_eq,
      JobApplication.statuses.keys.map { |s| [s.humanize, s] },
      include_blank: "All statuses",
      class: "form-select" %>
  <%= f.submit "Search", class: "btn btn-primary" %>
<% end %>
```

---

### P2-3: Enable Progressive Web App (PWA)

**File:** `app/views/layouts/application.html.erb`

**Problem:** PWA manifest tag is commented out: `<%# include_tags :manifest %>`.

**Suggested Solution:** Uncomment the manifest tag, verify `manifest.json` exists with correct content, and add a service worker for offline support:

```erb
<%# application.html.erb — uncomment: %>
<%= tag.link rel: "manifest", href: "/manifest.json" %>
<meta name="theme-color" content="#09637E">
```

Ensure `public/manifest.json` or `config/manifest.json` has:
```json
{
  "name": "OfferBound",
  "short_name": "OfferBound",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#e8f9ff",
  "theme_color": "#09637E",
  "icons": [...]
}
```

---

### P2-4: Enable N+1 Detection in Development

**File:** `Gemfile`, `config/environments/development.rb`

**Problem:** The Bullet gem is not installed. N+1 queries would go undetected during development.

**Suggested Solution:**

```ruby
# Gemfile
group :development do
  gem "bullet"
end
```

```ruby
# config/environments/development.rb
config.after_initialize do
  Bullet.enable = true
  Bullet.alert = true
  Bullet.rails_logger = true
  Bullet.add_footer = true
end
```

---

### P2-5: Add Troubleshooting Section to README

**File:** `README.md`

**Problem:** No troubleshooting section. New contributors will hit common setup issues with no guidance.

**Suggested Solution:** Add an FAQ section covering common issues:

```markdown
## Troubleshooting

**Database connection error on setup**
Ensure PostgreSQL is running: `brew services start postgresql`
Check `config/database.yml` for correct credentials.

**Background jobs not running**
In development, jobs run inline by default. In production, ensure Solid Queue is started:
`bundle exec rake solid_queue:start`

**AI recommendations not generating**
Verify `OPENAI_API_KEY` is set in your `.env` file and has available API credits.

**Assets not compiling**
Run `rails assets:precompile` and check for JavaScript errors in the browser console.
```

---

### P2-6: Remove or Implement Cloudinary/Carrierwave

**File:** `Gemfile`

**Problem:** `carrierwave` and `cloudinary` are installed but nothing uses them. This adds unnecessary dependency weight and suggests incomplete feature work.

**Suggested Solution (Option A):** Implement file uploads for job application attachments:

```ruby
# app/uploaders/attachment_uploader.rb
class AttachmentUploader < CarrierWave::Uploader::Base
  storage :fog  # or :cloudinary
end

# app/models/job_application.rb
mount_uploader :attachment, AttachmentUploader
```

**Suggested Solution (Option B):** Remove unused gems:
```ruby
# Remove from Gemfile:
gem "carrierwave"
gem "cloudinary"
```

---

### P2-7: Verify and Document AI Integration

**File:** `app/services/recommendations/generators/`

**Problem:** The `ai-chat` gem is in `Gemfile` but its usage is not visible in the scanned service files. If OpenAI calls are made directly (e.g., via `net/http` or another mechanism), this should be documented and confirmed working.

**Suggested Solution:** Ensure service generators reference the gem consistently:

```ruby
# Example if using ai-chat gem:
require "ai/chat"

class Recommendations::Generators::InterviewReflection
  def call(touchpoint)
    client = AI::Chat.new(api_key: Rails.application.credentials.openai_api_key)
    response = client.chat(prompt: build_prompt(touchpoint))
    response.content
  end
end
```

Add documentation in README for the AI feature and what API key is required.

---

*End of prioritized improvement plan.*
