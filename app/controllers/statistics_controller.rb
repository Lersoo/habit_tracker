class StatisticsController < ApplicationController
  def index
    @habits = Current.user.habits.active.includes(:completions)
    @total_habits = @habits.count
    @total_completions = @habits.sum(&:total_completions)
    @best_streak = @habits.map(&:longest_streak).max || 0
    @current_streaks = @habits.map { |h| { habit: h, streak: h.current_streak } }
                              .sort_by { |h| -h[:streak] }
                              .first(5)
  end
end
