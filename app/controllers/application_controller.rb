require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  check_authorization unless: :devise_controller?

  protect_from_forgery with: :exception

  before_action :gon_init

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.html { redirect_to root_url, alert: e }
      format.json { render json: { errors: e.message }, status: :forbidden }
      format.js   { head :forbidden }
    end
  end

  private

  def gon_init
    @user = current_user if current_user
    gon.user = @user
  end
end
