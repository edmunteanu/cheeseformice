class ErrorsController < ApplicationController
  before_action :default_format_html, only: :not_found

  def not_found
    render status: :not_found
  end

  def internal_server_error
    render status: :internal_server_error
  end

  private

  def default_format_html
    request.format = :html
  end
end
