require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(nickname: "test", password: "password123")
    expect(user).to be_valid
  end

  it "is not valid without an nickname" do
    user = User.new(password: "password123")
    expect(user).not_to be_valid
  end
end
