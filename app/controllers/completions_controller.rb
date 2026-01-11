class CompletionsController < ApplicationController
  before_action :set_habit

  def create
    date = Date.parse(params[:date])
    status = params[:status]

    @completion = @habit.completions.find_or_initialize_by(completed_on: date)
    @completion.status = status

    if @completion.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to habits_path }
      end
    else
      redirect_to habits_path, alert: t(".error")
    end
  end

  def destroy
    date = Date.parse(params[:date])
    @completion = @habit.completions.find_by(completed_on: date)
    @completion&.destroy

    respond_to do |format|
      format.turbo_stream { render :create }
      format.html { redirect_to habits_path }
    end
  end

  private

  def set_habit
    @habit = Current.user.habits.find(params[:habit_id])
  end
end
