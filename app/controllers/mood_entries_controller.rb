class MoodEntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @mood_entries = current_user.mood_entries.order(created_at: :asc)
    @recent_mood_entries = current_user.mood_entries.order(created_at: :desc).limit(5)

    # Get the last 14 days of mood entries for the chart
    recent_entries = current_user.mood_entries
                                 .where(entry_date: 14.days.ago.to_date..Date.today)
                                 .order(entry_date: :asc)

    # Prepare data for the chart
    @dates = recent_entries.map { |entry| entry.entry_date.strftime("%b %d") }
    @mood_scores = recent_entries.map(&:mood_level)

    # If no entries, provide empty arrays to avoid errors
    @dates ||= []
    @mood_scores ||= []

    # Hard-coded data for quadrant chart
    @points = [
      { x: -8, y: 6, label: "Point A" },
      { x: 5, y: 7, label: "Point B" },
      { x: -3, y: -4, label: "Point C" },
      { x: 7, y: -8, label: "Point D" },
      { x: 2, y: -2, label: "Point E" },
      { x: -6, y: -7, label: "Point F" },
      { x: -5, y: 2, label: "Point G" },
      { x: 4, y: 3, label: "Point H" }
    ]
  end

  def show
    @mood_entry = current_user.mood_entries.find(params[:id])
  end

  def new
    @mood_entry = current_user.mood_entries.new
  end

  def create
    @mood_entry = current_user.mood_entries.new(mood_entry_params)
    if @mood_entry.save
      redirect_to @mood_entry, notice: "Mood entry created successfully!"
    else
      render :new, status: :unprocessable_entity

    end
  end

  def edit
    @mood_entry = current_user.mood_entries.find(params[:id])
  end

  def update
    @mood_entry = current_user.mood_entries.find(params[:id])
    if @mood_entry.update(mood_entry_params)
      redirect_to @mood_entry, notice: "Mood entry updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @mood_entry = current_user.mood_entries.find(params[:id])
    @mood_entry.destroy
    redirect_to mood_entries_path, notice: "Mood entry deleted successfully!"
  end

  private

  def mood_entry_params
    params.require(:mood_entry).permit(:mood_level, :note)
  end
end
