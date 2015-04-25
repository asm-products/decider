require 'rails_helper'

describe User do
  describe 'validations' do
    let(:user) { build :user, email: 'email@example.com', name: 'user name' }

    specify { expect(user).to be_valid }

    it 'requires name' do
      user.name = nil
      expect(user).to_not be_valid
    end

    it 'requires email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'requires password' do
      user.password = nil
      expect(user).to_not be_valid
    end

    it "validates uniqueness of email" do
      create :user, email: "existing_email@example.com"
      invalid = build :user, email: "existing_email@example.com"
      expect(invalid.valid?).to eq false
    end
  end
end
