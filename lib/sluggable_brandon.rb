module SluggableBrandon
  extend ActiveSupport::Concern

  included do
    if self.to_s == 'Post'
      after_create :generate_slug
    else
      before_save :generate_slug
    end
  end

  def generate_slug
    attribute = case self.class.to_s
                when 'Category' then
                  self.name
                when 'Post' then
                  self.title
                when 'User' then
                  self.username
                else
                  nil
                end

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

      if self.class.to_s == 'Post'
        self.save
      end
    end
  end

  def to_param
    self.slug
  end
end
