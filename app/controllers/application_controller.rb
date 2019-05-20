# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Concerns::CommonErrorsConcern
  include Concerns::IncludeConcern
end
