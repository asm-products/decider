require 'rails_helper'

describe User do
  it "validates uniqueness of email" do
    create :user, email: "email@example.com"
    invalid = build :user, email: "email@example.com"
    expect(invalid.valid?).to eq false
  end
end