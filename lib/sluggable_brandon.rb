module SluggableBrandon
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_column
  end

  def generate_slug!
    attribute = self.send(self.class.slug_column.to_sym)

    unless attribute.nil?
      potential_slug = attribute.downcase.gsub(/\s+/, '-').gsub(/[^A-Za-z0-9-]/, '')

      index = 1

      until self.class.find_by(slug: potential_slug).nil?
        if index == 1
          potential_slug += "-#{index}"
        else
          potential_slug.gsub!(/-\d+$/, "-#{index}")
        end

        index += 1
      end

      self.slug = potential_slug
    end
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def sluggable_column(column_name)
      self.slug_column = column_name
    end
  end
end
