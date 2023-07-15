# frozen_string_literal: true

require "rails_helper"

RSpec.describe "管理者ログインテスト", type: :system do
  let(:admin) { create(:admin) }
  
  describe "管理者ログイン" do
    before do
      visit root_path
    end
    
    context "ログイン成功テスト" do
      it "管理者ログイン画面に遷移する" do
        link_element = find('.fa-user-cog').ancestor('a')
        link_element.click
        expect(current_path).to eq "/admin/sign_in"
      end
      
      it "管理者ログイン後、管理者トップページに遷移する" do
        visit new_admin_session_path
        fill_in "admin_email_input", with: admin.email
        fill_in "admin_password_input", with: admin.password
        click_button "ログイン"
        expect(current_path).to eq "/admin"
      end
    end
    
    context "ログイン失敗テスト" do
      it "ログイン画面にリダイレクトし、フラッシュメッセージが表示される" do
        visit new_admin_session_path
        fill_in "admin_email_input", with: ''
        fill_in "admin_password_input", with: ''
        click_button "ログイン"
        expect(current_path).to eq '/admin/sign_in'
        expect(page).to have_content 'Emailまたはパスワードが違います。'
      end
    end
  end
  
  describe "管理者ログアウト" do
    context "管理者ログアウトテスト" do
      before do
        visit new_admin_session_path
        fill_in "admin_email_input", with: admin.email
        fill_in "admin_password_input", with: admin.password
        click_button "ログイン"
      end
      it "ヘッダーからログアウトし、管理者ログイン画面に遷移する" do
        click_on "ログアウト"
        expect(current_path).to eq '/admin/sign_in'
      end
    end
  end

end