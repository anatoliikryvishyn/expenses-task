class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do |error|
    record = error.record
    render json: record.errors, status: :bad_request
  end
end
