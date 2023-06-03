# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :user_state, only: [:create]
  # user_state＝退会済みかどうかを判断するメソッドをprotected以下に定義

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  
  def after_sign_in_path_for(resource)
    mypage_path(resource)
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys:[:email])
  end
  
  def user_state
    @user = User.find_by(email: params[:user][:email])
    # 入力されたemailからアカウントを1件取得する
    return if !@user
    # アカウントを取得できなかった場合、このメソッドを終了する（！＝否定演算子）
    if @user.valid_password?(params[:user][:password]) && @user.is_active == false
    # 取得したアカウントのパスワードと入力されたパスワードが一致かつis_deletedがtrue（=退会済み）の場合
      flash[:alert]="退会済みです。再登録のうえご利用ください。"
      redirect_to new_user_registration_path
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
