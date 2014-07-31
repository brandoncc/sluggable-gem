module SluggableBrandon
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_column
  end

  def slug_exists?(slug)
    self.class.find_by(slug: slug).nil?
  end

  def generate_slug!
    attribute = self.send(self.class.slug_column.to_sym)

    unless attribute.nil?
      potential_slug = to_slug(attribute)

      index = 1

      until slug_exists?(potential_slug) || potential_slug == self.slug
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

  def to_slug(str)
    str.downcase.gsub(/\s+/, '-').gsub(/[^A-Za-z0-9-]+/, '').gsub(/-+/, '-')
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
