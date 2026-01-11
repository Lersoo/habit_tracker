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

  def current_streak
    streak = 0
    date = Date.current

    loop do
      completion = completions.completed.find_by(completed_on: date)
      break unless completion || date == Date.current

      streak += 1 if completion
      date -= 1.day
    end

    streak
  end

  def longest_streak
    completed_dates = completions.completed.order(:completed_on).pluck(:completed_on)
    return 0 if completed_dates.empty?

    max_streak = 1
    current_streak = 1

    completed_dates.each_cons(2) do |prev_date, curr_date|
      if curr_date - prev_date == 1
        current_streak += 1
        max_streak = [ max_streak, current_streak ].max
      else
        current_streak = 1
      end
    end

    max_streak
  end

  def completion_rate(days: 30)
    start_date = days.days.ago.to_date
    total_days = (Date.current - start_date).to_i + 1
    completed_count = completions.completed.where(completed_on: start_date..Date.current).count

    return 0 if total_days.zero?

    (completed_count.to_f / total_days * 100).round
  end

  def total_completions
    completions.completed.count
  end
end
