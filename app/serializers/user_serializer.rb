# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :avatar_url, :email, :full_name, :gender

  has_many :targets
end
