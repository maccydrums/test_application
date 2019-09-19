class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :set_locale,
  :set_js_translations
  def window_translations
    @translations = I18n.t(".")
   end

  private

  def set_js_translations
    @translations = I18n.t(".")
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    # current_user.locale 
    # request_env["HTTP_ACCEPT_LANGUAGE"]
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
