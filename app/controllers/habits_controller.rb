class HabitsController < ApplicationController
  before_action :set_habit, only: %i[show edit update destroy archive unarchive]

  def index
    @habits = Current.user.habits.active.order(:name)
  end

  def archived
    @habits = Current.user.habits.archived.order(:name)
  end

  def show
  end

  def new
    @habit = Current.user.habits.build
  end

  def edit
  end

  def create
    @habit = Current.user.habits.build(habit_params)

    if @habit.save
      redirect_to habits_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @habit.update(habit_params)
      redirect_to habits_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @habit.destroy
    redirect_to habits_path, notice: t(".success")
  end

  def archive
    @habit.update!(archived: true)
    redirect_to habits_path, notice: t(".success")
  end

  def unarchive
    @habit.update!(archived: false)
    redirect_to habits_path, notice: t(".success")
  end

  private

  def set_habit
    @habit = Current.user.habits.find(params[:id])
  end

  def habit_params
    params.require(:habit).permit(:name, :description, :frequency, :color)
  end
end
