# CLAUDE.md

This file provides guidance for Claude Code when working on this project.

## Project Overview

Habit Tracker is a Ruby on Rails 8.1 application for tracking daily habits and streaks. It uses PostgreSQL for the database, Hotwire (Turbo + Stimulus) for interactivity, and Tailwind CSS for styling.

## Tech Stack

- **Framework**: Ruby on Rails 8.1
- **Ruby Version**: 3.4.5
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS v4
- **Testing**: Minitest
- **Linting**: StandardRB
- **CI**: GitHub Actions

## Development Commands

```bash
# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate

# Run the server
bin/dev

# Run tests
bundle exec rails test

# Run linting
bundle exec standardrb

# Auto-fix linting issues
bundle exec standardrb --fix
```

## Project Structure

- `app/models/` - ActiveRecord models (User, Habit, HabitCompletion)
- `app/controllers/` - Rails controllers
- `app/views/` - ERB templates with Turbo Frame support
- `app/assets/tailwind/` - Tailwind CSS configuration with dark theme
- `test/` - Minitest test files
- `.github/workflows/ci.yml` - GitHub Actions CI configuration

## Key Patterns

### Authentication
Uses Rails 8's built-in authentication generator with custom registration controller.
- `Current.user` provides the current authenticated user
- `sign_in_as(user)` helper for tests

### Turbo Frames
Habits list uses Turbo Frames for seamless check-in updates:
```erb
<%= turbo_frame_tag dom_id(habit) do %>
  <!-- Habit card with check-in buttons -->
<% end %>
```

### I18n
All user-facing strings are in `config/locales/en.yml`. Use `t(".key")` in views.

### Streaks
Streak calculation is done in `Habit#current_streak` and `Habit#longest_streak` methods.

## Code Style

- Use StandardRB for Ruby style (run `bundle exec standardrb` before committing)
- Keep Tailwind classes inline in views
- Use dark theme colors defined in `app/assets/tailwind/application.css`
- Extract strings to i18n locales
- Keep code as explicit as possible. 
- Use meaningful variable names to improve readability.
- Don't rely on comments.
- Avoid unnecessary complexity and duplication. 
- Avoid magic numbers and strings. 
- Avoid extracting unnecessary methods or variables (e.g. `set_{model}` in controllers to set instance variables) 

## Testing

Tests are in `test/` directory:
- Model tests: `test/models/`
- Controller tests: `test/controllers/`
- Integration tests: `test/integration/`
- Fixtures: `test/fixtures/`

All tests must pass before merging PRs.

## CI Pipeline

GitHub Actions runs on every PR:
1. **Lint job**: Runs StandardRB
2. **Test job**: Runs full test suite with PostgreSQL

Both jobs must pass before merging.

--- 

Whenever a meaningful change is made, ensure it is thoroughly tested, and update the CLAUDE.md file accordingly.
Never add yourself as a commit author.
