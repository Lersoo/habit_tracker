class Habit < ApplicationRecord
  belongs_to :user
  has_many :completions, class_name: "HabitCompletion", dependent: :destroy

  enum :frequency, { daily: 0, weekdays: 1, weekends: 2, custom: 3 }

  validates :name, presence: true
  validates :frequency, presence: true
  validates :color, presence: true

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  def completion_for(date)
    completions.find_by(completed_on: date)
  end

  def completed_on?(date)
    completion_for(date)&.completed?
  end

  def skipped_on?(date)
    completion_for(date)&.skipped?
  end

  def status_for(date)
    completion_for(date)&.status
  end
end
