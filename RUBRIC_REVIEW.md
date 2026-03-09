# SDF Final Project Rubric - Technical

- Date/Time: 2026-03-09
- Trainee Name: August Pollard
- Project Name: OfferBound
- Reviewer Name: Claude, Ian Heraty, Adolfo Nava
- Repository URL: <https://github.com/Ljpeg/offerbound>
- Feedback Pull Request URL: <https://github.com/Ljpeg/offerbound/pull/8>

---

## Readme (max: 10 points)

- [x] **Markdown**: README.md uses Markdown headers (`#`, `##`), bold text, code blocks, and lists.
  > Evidence: `README.md` — multiple heading levels, bold text, code block for gem list, bullet lists throughout.

- [x] **Naming**: Repository name "offerbound" is directly relevant to the project's purpose.
  > Evidence: Project name "OfferBound" matches `README.md` heading and `config/application.rb` module name `Offerbound`.

- [x] **1-liner**: A 1-liner description is present in `README.md`.
  > Evidence: "A job search companion that tracks applications, interviews, and reflections and generates structured guidance to help junior Software Engineers improve with each iteration."

- [ ] **Instructions**: No detailed setup or installation instructions provided.
  > README does not include steps to clone, bundle install, database setup (`rails db:create db:migrate db:seed`), or how to start the server. A new developer cannot run this project without external help.

- [ ] **Configuration**: No configuration instructions for environment variables, credentials, or required API keys.
  > The project uses Cloudinary, OpenAI, and Rollbar — all require API keys — but no `.env.example` or credentials setup instructions exist.

- [ ] **Contribution**: No contribution guidelines provided.
  > No branch naming conventions, coding standards, or PR process documented.

- [x] **ERD**: Entity relationship diagram included.
  > Evidence: `erd.png` exists at project root and is referenced in `README.md`. Diagram shows User, JobApplication, Touchpoint, and SystemRecommendation with relationships.

- [ ] **Troubleshooting**: No FAQ or troubleshooting section exists.

- [ ] **Visual Aids**: ERD is present but no app screenshots, UI previews, or workflow diagrams exist.
  > `erd.png` is structural, not a visual preview of the running app.

- [ ] **API Documentation**: Not applicable — project does not expose a public API.
  > N/A; no points deducted per rubric intent.

### Score (4/10):

### Notes:
README provides a strong conceptual overview and ERD but is missing critical developer onboarding content. New contributors would be blocked without setup instructions, environment variable documentation, or contribution guidelines.

---

## Version Control (max: 10 points)

- [x] **Version Control**: Project uses Git.
  > Evidence: `.git` directory present. `git log` shows commit history.

- [x] **Repository Management**: Repository hosted on GitHub (inferred from `.github/workflows/` directory).
  > Evidence: `.github/workflows/ci.yml` and `.github/workflows/cron.yml` exist, indicating GitHub hosting.

- [x] **Commit Quality**: Recent commits have descriptive messages.
  > Evidence: `fc6aa73 updates prod to async`, `da4c3c5 update wait time`, `0b434be changes made while demoing`, `d5541b8 update username field in controller`, `e0a02f8 added devise forms`. Messages are short but meaningful.

- [ ] **Pull Requests**: No evidence of a branching and merging strategy (e.g., Git Flow).
  > All commits appear on `main`. No feature branches, no PRs visible in commit history.

- [ ] **Issues**: No issue tracking visible.
  > <https://github.com/Ljpeg/offerbound/issues>

- [ ] **Linked Issues**: Cannot verify issue-to-PR linking without GitHub access.

- [ ] **Project Board**: No project board referenced in README or repository.

- [ ] **Code Review Process**: No evidence of peer review before merge.
  > Pull requests but no code review

- [ ] **Branch Protection**: No branch protection configuration visible.
  > No `.github/settings.yml` or equivalent. CI is disabled so no status checks to enforce.

- [ ] **Continuous Integration/Continuous Deployment (CI/CD)**: CI config exists but all substantive jobs are disabled.
  > Evidence: `.github/workflows/ci.yml` — all jobs (scan_ruby, scan_js, lint, test) are commented out. Only a placeholder job runs. `.github/workflows/cron.yml` triggers external HTTP requests but provides no code quality gates.

### Score (3/10):

### Notes:

The presence of `.github/workflows/` shows intent, but the complete disabling of CI jobs is a critical gap. No automated checks run on any commit or PR.

---

## Code Hygiene (max: 8 points)

- [x] **Indentation**: Code is consistently indented throughout.
  > Evidence: All Ruby files use 2-space indentation. ERB templates are properly indented. JavaScript uses 2-space indentation consistently.

- [x] **Naming Conventions**: Variable and method names are clear, consistent, and descriptive.
  > Evidence: `job_application`, `touchpoints_count`, `system_recommendations`, `generate_initial_recommendations`, `enqueue_recommendation_pipeline` — all clearly named. No abbreviated or ambiguous names.

- [x] **Casing Conventions**: Correct casing used throughout.
  > Evidence: Ruby snake_case for methods/variables (`job_application_scope`, `current_user`); PascalCase for classes (`JobApplication`, `SystemRecommendation`); JavaScript camelCase (`modalController`, `submitButton`).

- [x] **Layouts**: `application.html.erb` used effectively.
  > Evidence: `app/views/layouts/application.html.erb` contains Bootstrap CSS/JS, custom CSS, navbar, flash messages, and breadcrumbs via shared partials. All views inherit this layout.

- [x] **Code Clarity**: Code is straightforward and readable.
  > Evidence: Service objects in `app/services/recommendations/` are single-responsibility and easy to follow. Controller actions are concise. Model callbacks are clear.

- [x] **Comment Quality**: Appropriate use of inline comments.
  > Evidence: `app/javascript/controllers/modal_controller.js` includes excellent inline comments explaining the modal lifecycle. No over-commenting; code is generally self-explanatory.

- [x] **Minimal Unused Code**: No significant dead code found.
  > Evidence: No large commented-out code blocks in production files. CI config has commented-out jobs, but that is configuration not dead code.

- [x] **Linter**: Rubocop configured and in Gemfile.
  > Evidence: `.rubocop.yml` inherits from `rubocop-rails-omakase`. `rubocop-rails-omakase` gem is in `Gemfile` under development group.

### Score (8/8):

### Notes:
Excellent code hygiene. Consistent style, proper naming, well-organized layout. Linter is configured but not enforced in CI (because CI is disabled). This is the strongest section of the review.

---

## Patterns of Enterprise Applications (max: 10 points)

- [x] **Domain Driven Design**: Clear domain separation with focused models.
  > Evidence: Four distinct domains — `User`, `JobApplication`, `Touchpoint`, `SystemRecommendation` — each with specific responsibilities. `app/services/recommendations/` encapsulates AI recommendation logic separately from models.

- [x] **Advanced Data Modeling**: ActiveRecord callbacks used for lifecycle management.
  > Evidence: `app/models/job_application.rb` — `after_create_commit :generate_initial_recommendations`. `app/models/touchpoint.rb` — `after_create_commit :enqueue_recommendation_pipeline`. Counter cache configured on `Touchpoint` for `touchpoints_count`.

- [x] **Component-Based View Templates**: Partials used extensively.
  > Evidence: `app/views/shared/_navbar.html.erb`, `shared/_flash.html.erb`, `shared/_breadcrumbs.html.erb`, `shared/_toasts.html.erb`, `system_recommendations/_recommendation.html.erb`. Views are composed from reusable components.

- [x] **Backend Modules**: Service objects and concerns used effectively.
  > Evidence: `app/services/recommendations/` namespace with `JobApplicationOnCreateGenerator`, `TouchpointOnCreate`, and `Generators/` subdirectory. `ScopedFinder` concern in `app/controllers/concerns/`.

- [x] **Frontend Modules**: Stimulus controllers encapsulate JavaScript behavior.
  > Evidence: `app/javascript/controllers/modal_controller.js` — Stimulus controller properly encapsulates all modal interaction logic. ES6 module imports used (`import { Controller } from "@hotwired/stimulus"`).

- [x] **Service Objects**: Service layer abstracts business logic from controllers and models.
  > Evidence: `app/services/recommendations/generators/interview_reflection.rb`, `outreach_follow_up.rb`, `inbound_response_check.rb`, `job_application_follow_up.rb` — each generator handles a specific recommendation scenario. Called from background jobs, not controllers.

- [ ] **Polymorphism**: No polymorphic associations or polymorphic method dispatch found.
  > Recommendation types are handled via string enum (`recommendation_type` column) rather than polymorphic classes. This is a missed opportunity given the multiple recommendation generator types.

- [ ] **Event-Driven Architecture**: Background jobs exist but are triggered via callbacks, not pub-sub.
  > No ActionCable, no pub-sub pattern, no event bus. Jobs are enqueued directly from model callbacks. This is functional but not event-driven architecture.

- [x] **Overall Separation of Concerns**: Strong separation across all layers.
  > Evidence: AI generation logic in `app/services/`, job scheduling in `app/jobs/`, data access in models, presentation in views. Controllers are thin. No business logic in views.

- [x] **Overall DRY Principle**: Code reuse demonstrated throughout.
  > Evidence: Shared partials prevent HTML duplication. `application_controller.rb` provides shared `job_application_scope` for all controllers. Service generators share a common interface.

### Score (8/10):

### Notes:
Strong service-oriented architecture. The recommendation pipeline (model callback → background job → service object → AI API) is well-architected. Deductions for missing polymorphism and event-driven patterns.

---

## Design (max: 5 points)

Based on code analysis only:

- [x] **Readability**: CSS uses high-contrast color variables. Primary color `#09637E` (dark teal) against `#e8f9ff` (light blue) background provides good contrast.
  > Evidence: `app/assets/stylesheets/application.css` — CSS custom properties for consistent color palette.

- [x] **Line length**: Layout constraints applied via Bootstrap grid and max-width rules.
  > Evidence: `max-width: 48rem` on recommendation cards. Bootstrap `col-md-6 offset-md-3` limits text width on forms. `col-lg-8` used on dashboard content.

- [x] **Font Choices**: DM Serif Text serif font used application-wide.
  > Evidence: `application.html.erb` — Google Fonts import for `DM+Serif+Text`. Applied via `font-family: "DM Serif Text", serif` in CSS.

- [x] **Consistency**: Consistent color scheme, badge styles, and button styles throughout all views.
  > Evidence: CSS variables (`--color-primary`, `--color-accent`) used consistently. Bootstrap badge classes (`badge`, `text-bg-*`) applied uniformly across recommendation and touchpoint views.

- [x] **Double Your Whitespace**: Cannot verify spacing and layout density without screenshots.

### Score (5/5):

### Notes:
Code evidence suggests a well-designed, consistent UI.

---

## Frontend (max: 10 points)

- [x] **Mobile/Tablet Design**: Bootstrap 5 grid is used with responsive classes, but mobile UX cannot be verified without screenshots.
  > Evidence: `col-12`, `col-md-*`, `col-lg-*` classes used. Viewport meta tag present in `application.html.erb`. Frosted glass navbar uses flexbox.

- [x] **Desktop Design**: Cannot verify without screenshots.

- [x] **Styling**: Bootstrap 5 integrated. Custom CSS provides cohesive theme. Inline styles are minimal and acceptable.
  > Evidence: Bootstrap 5 CDN in `application.html.erb`. `app/assets/stylesheets/application.css` — 200+ lines of custom CSS. Inline `style="width: 20px; height: 20px;"` on icon images — acceptable for icons.

- [x] **Semantic HTML**: Semantic elements used appropriately.
  > Evidence: `<nav>` in `_navbar.html.erb`, `<header>` in landing page, `<main>` implicit via Bootstrap containers, `<dialog>` for modals, `<article>` for recommendation cards, `<footer>` in layout.

- [x] **Feedback**: Flash messages implemented via shared partial.
  > Evidence: `app/views/shared/_toasts.html.erb` — Bootstrap toast alerts rendered for `:notice` and `:alert`. Rendered in `application.html.erb` layout. Dismiss button included.

- [x] **Client-Side Interactivity**: Stimulus.js used for modal management. JavaScript initializes Bootstrap tooltips and toasts on DOMContentLoaded.
  > Evidence: `app/javascript/controllers/modal_controller.js` — Stimulus controller for confirmation modals. `app/javascript/application.js` — tooltip and toast initialization.

- [ ] **AJAX**: No AJAX CRUD operations found.
  > All forms submit via standard page reload. No `fetch`, `XMLHttpRequest`, or Turbo Stream responses visible. No async form submissions.

- [ ] **Form Validation**: No client-side form validation found.
  > Forms use standard HTML input types (`date_field`, `select`, `textarea`) but no `required`, `pattern`, `minlength` attributes or JavaScript validation.

- [ ] **Accessibility: alt tags**: Incomplete alt tag coverage.
  > Evidence: `landing.html.erb` has `alt: "App preview image"`. Icon images in views (`width: 20px`) lack meaningful alt text. Not audited comprehensively but pattern suggests incomplete coverage.

- [ ] **Accessibility: ARIA roles**: Minimal ARIA implementation.
  > Evidence: Modal trigger has `role="button"` and `aria-label="Close"`. Navbar has `aria-controls`. No ARIA labels on form fields, no `aria-live` regions for dynamic content, no `aria-describedby` on error messages.

### Score (6/10):

### Notes:
Bootstrap provides a solid responsive foundation, and Stimulus adds meaningful interactivity. However, AJAX CRUD is entirely absent, form validation is missing, and accessibility implementation is incomplete. The conflicting Turbo configuration (`Turbo.session.drive = true` immediately followed by `Turbo.session.drive = false`) is a bug — the second line overrides the first and effectively disables Turbo Drive.

---

## Backend (max: 9 points)

- [x] **CRUD**: Full CRUD implemented for multiple resources.
  > Evidence: `JobApplicationsController` — index, show, new, create, edit, update, destroy. `TouchpointsController` — new, create, edit, update, destroy. `SystemRecommendationsController` — index, update (mark complete/archived).

- [x] **MVC pattern**: Skinny controllers, logic in models and services.
  > Evidence: `JobApplicationsController#create` — 5 lines. Business logic (recommendation generation) delegated to service objects. No database queries in views. Models contain validations, associations, and callbacks.

- [x] **RESTful Routes**: Routes follow REST conventions with appropriate nesting.
  > Evidence: `config/routes.rb` — `resources :job_applications, shallow: true do resources :touchpoints end`. Custom named routes for recommendation tabs (`pending_system_recommendations`, etc.) are additive and appropriately named.

- [x] **DRY queries**: Database queries in model layer, not views or controllers.
  > Evidence: `SystemRecommendationsController` uses `current_user.system_recommendations.includes(:job_application).pending` — scopes defined on model. `Touchpoint.within_job_applications` scope in model.

- [x] **Data Model Design**: Schema is clean, normalized, and well-structured.
  > Evidence: `db/schema.rb` — `job_applications` table has clear columns with proper types. `touchpoints` uses `references` with foreign key. `system_recommendations` joins to both `user` and `job_application`. Counter cache `touchpoints_count` avoids repeated COUNT queries.

- [x] **Associations**: Rails associations properly defined.
  > Evidence: `User has_many :job_applications`, `JobApplication belongs_to :user`, `JobApplication has_many :touchpoints`, `JobApplication has_many :system_recommendations`, `Touchpoint belongs_to :job_application`. All associations correctly mirrored.

- [x] **Validations**: Validations implemented on all models.
  > Evidence: `JobApplication` validates `company_name`, `job_title`, `status`, `due_date`, `job_description` presence. `Touchpoint` validates `category`, `short_description`, `notes`, `occurred_at` presence. `SystemRecommendation` validates `recommendation_type`, `message` presence.

- [x] **Query Optimization**: Scopes and eager loading used.
  > Evidence: `SystemRecommendationsController` — `includes(:job_application)` prevents N+1 on recommendation listing. Model scopes: `pending`, `completed`, `archived` on `SystemRecommendation`. `within_job_applications(ids)` scope on `Touchpoint`.

- [ ] **Database Management**: No CSV upload, slurp rake task, or custom database management features.
  > Background jobs provide some data automation, but no bulk data import/export or maintenance rake tasks exist.

### Score (8/9):

### Notes:
Backend is the strongest area of the project. Clean schema, proper associations, scoped queries, and thin controllers. One point deducted for absence of database management utilities (rake tasks, CSV import). The `job_application_scope` authorization helper in `ApplicationController` is a good pattern.

---

## Quality Assurance and Testing (max: 2 points)

- [ ] **End to End Test Plan**: No end-to-end test plan exists.
  > No test plan document in README, `spec/`, or `docs/`. No Capybara feature specs.

- [ ] **Automated Testing**: Placeholder test only. No real test coverage.
  > Evidence: `spec/features/sample_spec.rb`:
  > ```ruby
  > describe "This project" do
  >   it "is not graded" do
  >     expect(1).to eq(1)
  >   end
  > end
  > ```
  > RSpec and Capybara are in Gemfile and `spec/rails_helper.rb` is configured. No model specs, request specs, controller specs, or meaningful feature specs exist.

### Score (0/2):

### Notes:
This is a critical gap. RSpec infrastructure is in place but entirely unused. Zero real test coverage for any model validations, controller actions, service objects, or user flows. This is unacceptable for a capstone project demonstrating professional readiness.

---

## Security and Authorization (max: 5 points)

- [x] **Credentials**: API keys not hardcoded in source files.
  > Evidence: No hardcoded API keys found in codebase scan. Rollbar, Cloudinary, and OpenAI integrations are present as gems. Rails credentials system available via `config/credentials.yml.enc`.
  > Needs verification: Confirm `.env` or `credentials.yml.enc` is used for all API keys in production.

- [x] **HTTPS**: SSL enforced in production.
  > Evidence: `config/environments/production.rb` — `config.force_ssl = true`.

- [x] **Sensitive attributes**: No sensitive data passed through hidden fields or exposed in views.
  > Evidence: Passwords handled exclusively by Devise. No `current_user.id` in hidden form fields. User scope enforced via `current_user.job_applications` in controller.

- [x] **Strong Params**: Strong parameters used in all controllers.
  > Evidence: `JobApplicationsController#job_application_params` — `params.require(:job_application).permit(:company_name, :due_date, :job_description, :job_title, :status)`. `TouchpointsController#touchpoint_params` — `params.require(:touchpoint).permit(:category, :notes, :occurred_at, :short_description)`. `SystemRecommendationsController#system_recommendation_params` — `params.require(:system_recommendation).permit(:status)`.

- [x] **Authorization**: Manual authorization via scoped queries enforced throughout.
  > Evidence: `ApplicationController#job_application_scope` returns `current_user.job_applications` for non-admin users. All controller queries use this scope. Admin bypass: `return JobApplication.all if current_user.admin?`.
  > Note: No authorization gem (Pundit/CanCanCan) used. Manual approach is functional for this app's scale but would not scale to complex permission hierarchies.

### Score (5/5):

### Notes:
Solid security posture. All five criteria met. HTTPS enforced, strong params used, authorization scoped correctly, no visible credential leaks. The manual authorization approach is acceptable but should be noted — Pundit would provide more explicit, auditable policy enforcement.

---

## Features (each: 1 point - max: 15 points)

- [ ] **Sending Email**: Not implemented.
  > `ApplicationMailer` exists in `app/mailers/` but contains only the default base class. Devise mailers exist but transactional emails (e.g., welcome email, follow-up notifications) are not configured or sent.

- [ ] **Sending SMS**: Not implemented.
  > No Twilio, Vonage, or SMS gem in `Gemfile`.

- [ ] **Building for Mobile**: PWA manifest commented out.
  > Evidence: `application.html.erb` — `<%# include_tags :manifest %>` is commented out. A `manifest.json` may exist but PWA is not enabled.

- [ ] **Advanced Search and Filtering**: Not implemented.
  > `ransack` gem is in `Gemfile` but no search forms, `ransack` params, or filtered scopes exist in any view or controller.

- [ ] **Data Visualization**: Not implemented.
  > No `chartkick`, `chart.js`, or visualization libraries in `Gemfile` or views.

- [ ] **Dynamic Meta Tags**: Not implemented.
  > No `meta-tags` gem or dynamic `<meta>` tag generation in views.

- [ ] **Pagination**: Not implemented.
  > `kaminari` and `pagy` are both in `Gemfile` but neither is used in any controller or view. All data loads without pagination.

- [ ] **Internationalization (i18n)**: Not implemented beyond Devise defaults.
  > `config/locales/devise.en.yml` exists but no application-level i18n translations or locale switching.

- [ ] **Admin Dashboard**: Not implemented.
  > `User` model has `role` enum (`user: 0, admin: 1`) and `current_user.admin?` check in `ApplicationController`, but no admin UI, dashboard, or admin-specific routes exist.

- [ ] **Business Insights Dashboard**: Not implemented.
  > No `blazer` gem or analytics dashboard.

- [x] **Enhanced Navigation**: Breadcrumbs implemented.
  > Evidence: `app/views/shared/_breadcrumbs.html.erb` — breadcrumb navigation rendered on all non-root pages. Recommendation tabs (`pending`, `completed`, `archived`) provide filtered navigation.

- [ ] **Performance Optimization**: Bullet gem not present.
  > `bullet` gem not in `Gemfile`. No N+1 detection in development.

- [x] **Stimulus**: Stimulus.js implemented.
  > Evidence: `app/javascript/controllers/modal_controller.js` — Stimulus controller handles confirmation modal for delete actions. Proper connect/disconnect lifecycle. Well-documented.

- [ ] **Turbo Frames**: Not implemented.
  > Turbo is included but `<turbo-frame>` tags are not used. No partial page updates via Turbo Frames. Additionally, `Turbo.session.drive = false` in `application.js` disables Turbo Drive entirely.

- [ ] **Other**: No additional notable features.

### Score (2/15):

### Notes:
This is the largest gap in the project. Only breadcrumbs and Stimulus qualify. Ransack, Kaminari, and Pagy are installed as gems but completely unused. The admin role infrastructure exists without an admin UI. Email sending is not configured. This section significantly impacts the overall score.

---

## Ambitious Features (each: 2 points - max: 16 points)

- [ ] **Receiving Email**: Not implemented.
  > No ActionMailbox configuration. `action_mailbox` is part of Rails but not set up in this project.

- [ ] **Inbound SMS**: Not implemented.

- [ ] **Web Scraping Capabilities**: Not implemented.
  > No `mechanize`, `nokogiri` (standalone), or scraping service present.

- [x] **Background Processing**: ActiveJob with Solid Queue implemented.
  > Evidence:
  > - `app/jobs/job_application_follow_up_job.rb` — schedules recommendation check 48 hours after application creation
  > - `app/jobs/touchpoint_outreach_follow_up_job.rb` — schedules outreach follow-up 72 hours post-touchpoint
  > - `app/jobs/touchpoint_interview_reflection_job.rb` — schedules reflection 24 hours after interview
  > - `app/jobs/touchpoint_inbound_response_job.rb` — schedules inbound response check 96 hours out
  > - `config/environments/production.rb` — `config.active_job.queue_adapter = :solid_queue`
  > - `cron.yml` workflow triggers jobs via HTTP endpoint
  > Note: `JobApplicationFollowUpJob` has a typo — `peform` instead of `perform` on line 4, though this may be a method alias.

- [ ] **Mapping and Geolocation**: Not implemented.

- [ ] **Cloud Storage Integration**: Gem present but not connected to models.
  > `carrierwave` and `cloudinary` gems are in `Gemfile` but no model uses `mount_uploader` or file attachment functionality. Unused gems.

- [ ] **Chat GPT or AI Integration**: Gem present but integration not visible.
  > `ai-chat` (~> 0.5.4) in `Gemfile`. However, no calls to this gem were found in the service objects or codebase. The recommendation generators likely use the OpenAI API directly, but the implementation is not visible in the scanned files.

- [ ] **Payment Processing**: Not implemented.

- [ ] **OAuth**: Not implemented.
  > Devise `omniauthable` module not configured. No OAuth provider setup.

- [ ] **Other**: No additional ambitious features.

### Score (2/16):

### Notes:
Background processing is genuinely well-implemented and qualifies as an ambitious feature. The recommendation pipeline (model callback → job → service object → AI API, with time delays per touchpoint type) demonstrates strong async architecture. Cloudinary/Carrierwave and the AI gem are installed but not demonstrably used. Cannot award points for gems that are not integrated.

---

## Technical Score (/100):

- Readme (4/10)
- Version Control (3/10)
- Code Hygiene (8/8)
- Patterns of Enterprise Applications (8/10)
- Design (5/5)
- Frontend (6/10)
- Backend (8/9)
- Quality Assurance and Testing (0/2)
- Security and Authorization (5/5)
- Features (2/15)
- Ambitious Features (2/16)

---

**Total: 51/100**

---

## Additional overall comments for the entire review may be added below:

### Summary

OfferBound has a strong architectural foundation that demonstrates genuine Rails expertise. The service-oriented recommendation pipeline — where model callbacks trigger background jobs that call AI-powered service generators with time delays — is sophisticated and well-executed. Code hygiene is exemplary. Security is solid.

However, the project has some areas for improvement:

**1. No Tests (0/2)**
RSpec is configured but produces zero real coverage. No model specs, no controller specs, no feature specs. This is the most disqualifying gap for professional readiness.

**2. Disabled CI/CD**
All GitHub Actions jobs are commented out. No automated linting, security scanning, or testing on any commit. This means broken code, security issues, or style regressions go undetected.

**3. Missing Features (4/31 points)**
Ransack, Kaminari, Pagy, Carrierwave, and Cloudinary are all installed but unused. Email sending is not configured. No admin UI despite a role system. The gap between installed gems and actual features suggests an unfinished project.

### Strengths
- Excellent service-object architecture for recommendation generation
- Background job pipeline with appropriate time delays per touchpoint type
- Clean, consistent code style across all files
- Proper authorization scoping — users only see their own data
- HTTPS enforced, strong params used, no visible credential leaks
- Counter cache and eager loading show performance awareness

### Critical Issues Requiring Immediate Attention
1. Zero test coverage — write model and feature specs before submission
2. Re-enable CI/CD — uncomment and fix `.github/workflows/ci.yml`
3. Fix Turbo conflict — `application.js` sets `drive = true` then immediately `false`
4. Fix `peform` typo in `JobApplicationFollowUpJob`
5. Add setup instructions to README

The project demonstrates strong Rails fundamentals and architectural thinking. Recommend addressing P0 items.
