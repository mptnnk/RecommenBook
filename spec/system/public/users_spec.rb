# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ユーザー登録に関するテスト", type: :system do
  describe "ユーザー新規登録" do
    before do
      visit root_path
    end

    it "新規登録画面へ遷移する" do
      click_on "会員登録", match: :first
      expect(current_path).to eq "/users/sign_up"
    end

    context "新規登録に成功する" do
      let(:user_name) { Faker::Lorem.characters(number: 10) }
      before do
        visit new_user_registration_path
        fill_in "new_name_input", with: user_name
        fill_in "new_email_input", with: Faker::Internet.email
        fill_in "new_password_input", with: "password"
        fill_in "new_password_confirmation_input", with: "password"
      end

      it "正しく新規登録される" do
        expect { click_button "会員登録" }.to change(User.all, :count).by(1)
      end

      it "新規登録後のリダイレクト先がユーザーのマイページになっている" do
        click_button "会員登録"
        expect(current_path).to eq "/users/#{user_name}"
      end
    end
  end

  describe "ユーザーログイン" do
    let(:user) { create(:user) }
    before do
      visit root_path
    end
    
    context "ログイン" do
      it "ヘッダーからログイン画面に遷移できる" do
        click_on "ログイン", match: :first
        expect(current_path).to eq "/users/sign_in"
      end
      
      it "ログイン画面からログインし、マイページに遷移する" do
        visit new_user_session_path
        fill_in "login_email_input", with: user.email
        fill_in "login_password_input", with: user.password
        click_button "ログイン"
        expect(current_path).to eq "/users/#{user.name}"
      end
    end
    
    # トップページのパーシャルでのログインテストを調べて実装する

    context "ログイン失敗テスト" do
      it "ログインに失敗し、ログイン画面にリダイレクトする" do
        visit new_user_session_path
        fill_in "login_email_input", with: ''
        fill_in "login_password_input", with: ''
        click_button "ログイン"
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe "ユーザーログアウト" do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in "login_email_input", with: user.email
      fill_in "login_password_input", with: user.password
      click_button "ログイン"
    end
    it "ヘッダーからログアウトし、トップページに遷移する" do
      click_on "ログアウト"
      expect(current_path).to eq '/'
    end
  end

  describe "プロフィール変更" do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in "login_email_input", with: user.email
      fill_in "login_password_input", with: user.password
      click_button "ログイン"
    end
    it "プロフィール変更画面に遷移する" do
      click_link "", href: users_information_edit_path
      expect(current_path).to eq '/users/information/edit'
    end
    it "プロフィール変更し、マイページに遷移する" do
      visit users_information_edit_path
      
    end
  end
end
