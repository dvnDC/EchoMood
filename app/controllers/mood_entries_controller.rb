class MoodEntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @mood_entries = current_user.mood_entries
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
