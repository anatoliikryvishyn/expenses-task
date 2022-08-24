class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do |error|
    record = error.record
    render json: record.errors, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do |error|
    render json: error.to_json, status: :not_found
  end
end
