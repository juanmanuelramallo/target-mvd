# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :avatar_url, :email, :full_name, :gender

  has_many :targets
end
