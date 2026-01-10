class Habit < ApplicationRecord
  belongs_to :user
  has_many :completions, class_name: "HabitCompletion", dependent: :destroy

  enum :frequency, { daily: 0, weekdays: 1, weekends: 2, custom: 3 }

  validates :name, presence: true
  validates :frequency, presence: true
  validates :color, presence: true

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
end
