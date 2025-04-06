require 'rails_helper'

RSpec.describe "MoodEntries", type: :request do
  let!(:user) { create(:user) }
  before { sign_in user }

  describe 'POST /mood_entries' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        { mood_entry: { mood_level: 5, note: 'Feeling great!', entry_date: Date.today } }
      end

      it 'creates a new mood entry' do
        expect {
          post mood_entries_path, params: valid_attributes
        }.to change(MoodEntry, :count).by(1)
      end

      it 'redirects to the mood entry show page (or index)' do
        post mood_entries_path, params: valid_attributes
        expect(response).to have_http_status(:redirect)
      end

      it 'creates the mood entry with the correct attributes' do
        post mood_entries_path, params: valid_attributes
        created_entry = MoodEntry.last
        expect(created_entry.mood_level).to eq(5)
        expect(created_entry.note).to eq('Feeling great!')
        expect(created_entry.user).to eq(user)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        { mood_entry: { mood_level: nil } }
      end

      it 'does not create a new MoodEntry' do
        expect {
          post mood_entries_path, params: invalid_attributes
        }.to_not change(MoodEntry, :count)
      end

      it 'returns an unprocessable entity status' do
        post mood_entries_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end