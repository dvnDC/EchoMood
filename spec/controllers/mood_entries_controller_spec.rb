require 'rails_helper'

RSpec.describe MoodEntriesController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'POST #create' do
    it 'creates a new mood entry' do
      expect {
        post :create, params: { mood_entry: { mood_level: 5, note: 'Feeling great!', entry_date: Date.today } }
      }.to change(MoodEntry, :count).by(1)
    end
  end
end