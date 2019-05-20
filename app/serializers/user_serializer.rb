# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :email

  has_many :targets
end
