module SingletonModel
  extend ActiveSupport::Concern

  class_methods do
    def instance
      first_or_create!
    end
  end
end
