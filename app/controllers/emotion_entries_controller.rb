class EmotionEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emotion_entry, only: [:show, :edit, :update, :destroy]

  def index
    @emotion_entries = current_user.emotion_entries.order(date: :desc, entry_time: :desc)

    @recent_emotion_entries = @emotion_entries.limit(5)

    @chart_data = @emotion_entries.map do |entry|
      {
        x: entry.valence,
        y: entry.arousal,
        label: "#{entry.date.strftime("%d-%m")} #{entry.entry_time.strftime("%H:%M")}",
        id: entry.id
      }
    end
  end

  def all
    @emotion_entries = current_user.emotion_entries.order(date: :desc, entry_time: :desc)
    render :all_entries
  end

  def show
  end

  def new
    @emotion_entry = current_user.emotion_entries.build(
      date: Date.current,
      entry_time: Time.current
    )
  end

  def create
    @emotion_entry = current_user.emotion_entries.build(emotion_entry_params)

    if @emotion_entry.save
      redirect_to emotion_entries_path, notice: 'Wpis emocji został pomyślnie utworzony.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @emotion_entry.update(emotion_entry_params)
      redirect_to emotion_entries_path, notice: 'Wpis emocji został pomyślnie zaktualizowany.'
    else
      render :edit
    end
  end

  def destroy
    @emotion_entry.destroy
    redirect_to emotion_entries_path, notice: 'Wpis emocji został usunięty.'
  end

  private

  def set_emotion_entry
    @emotion_entry = current_user.emotion_entries.find(params[:id])
  end

  def emotion_entry_params
    params.require(:emotion_entry).permit(:valence, :arousal, :notes, :date, :entry_time)
  end
end
