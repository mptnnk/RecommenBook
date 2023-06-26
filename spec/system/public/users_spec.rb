# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'ユーザー登録に関するテスト', type: :system do
  
  describe 'ユーザー新規登録' do
    before do
      visit root_path
    end
    it '新規登録画面へ遷移する' do
      click_on '会員登録', match: :first
      expect(current_path).to eq '/users/sign_up'
    end
    context '新規登録に成功する' do
      let!(:user_name) { Faker::Lorem.characters(number: 10)}
      before do
        visit new_user_registration_path
        fill_in 'new_name_input', with: user_name
        fill_in 'new_email_input', with: Faker::Internet.email
        fill_in 'new_password_input', with: 'password'
        fill_in 'new_password_confirmation_input', with: 'password'
      end
      it '正しく登録され、自分の名前のマイページに遷移する' do
        expect { click_button '会員登録' }.to change(User.all, :count).by(1)
        expect(current_path).to eq "/users/#{user_name}"
      end
    end
  end
  
  describe 'ユーザーログイン' do
    
  end
  
  describe 'ユーザーログアウト' do
    
  end
  
  describe 'プロフィール変更' do
    
  end
  
end