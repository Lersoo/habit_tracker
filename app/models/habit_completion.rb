class HabitCompletion < ApplicationRecord
  belongs_to :habit

  enum :status, { completed: 0, skipped: 1 }

  validates :completed_on, presence: true
  validates :completed_on, uniqueness: { scope: :habit_id }
  validates :status, presence: true

  scope :on_date, ->(date) { where(completed_on: date) }
  scope :completed_only, -> { where(status: :completed) }
end
