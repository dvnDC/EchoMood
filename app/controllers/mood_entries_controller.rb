class MoodEntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @mood_entries = current_user.mood_entries.order(created_at: :asc)
    @recent_mood_entries = current_user.mood_entries.order(created_at: :desc).limit(5)

    if params[:month].present?
      selected_date = Date.parse("#{params[:month]}-01")
    else
      selected_date = Date.today
    end

    start_date = selected_date.beginning_of_month
    end_date = selected_date.end_of_month

    start_of_grid = start_date.beginning_of_week(:monday)
    end_of_grid = end_date.end_of_week(:monday)

    @month_date = start_date
    @prev_month = (start_date - 1.month).strftime("%Y-%m")
    @next_month = (start_date + 1.month).strftime("%Y-%m")
    @current_month = start_date.strftime("%Y-%m")

    @mood_grid_data = {}

    (start_of_grid..end_of_grid).each do |date|
      @mood_grid_data[date] = nil
    end

    mood_entries_in_range = current_user.mood_entries
                                        .where(entry_date: start_of_grid..end_of_grid)
                                        .order(entry_date: :asc)

    mood_entries_in_range.each do |entry|
      @mood_grid_data[entry.entry_date] = entry
    end

    recent_entries = current_user.mood_entries
                                 .where(entry_date: 14.days.ago.to_date..Date.today)
                                 .order(entry_date: :asc)

    @dates = recent_entries.map { |entry| entry.created_at.strftime("%b %d") }
    @mood_scores = recent_entries.map(&:mood_level)

    # If no entries, provide empty arrays to avoid errors
    @dates ||= []
    @mood_scores ||= []

    @latest_mood_entry = current_user.mood_entries.order(created_at: :desc).first
  end


  def all
    @mood_entries = current_user.mood_entries.order(entry_date: :desc, created_at: :desc)
    render :all_entries
  end

  def show
    @mood_entry = current_user.mood_entries.find(params[:id])
  end

  def new
    @mood_entry = current_user.mood_entries.new
  end

  def create
    @mood_entry = current_user.mood_entries.new(mood_entry_params)

    respond_to do |format|
      if @mood_entry.save
        AiSuggestionJob.perform_later(@mood_entry.id)

        format.html { redirect_to mood_entries_path, notice: 'Mood entry was successfully created.' }
        format.json { render :show, status: :created, location: @mood_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mood_entry.errors, status: :unprocessable_entity }
      end
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
