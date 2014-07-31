#sluggable_brandon

##Overview
This project was built as an assignment from my Tealeaf Academy course.

##Usage in Rails
1. Add a 'slug' column, of string type,  to your model's database.
2. Add the gem to your GemFile
```ruby
gem 'sluggable_brandon'
```
3. Call the `sluggable_column` method in your model. Pass the method a symbol of the attribute that you want to use to build the slug.
```ruby
sluggable_column :username # build slug using the string from the username column
```
4. Call `generate_slug!` using an ActiveRecord callback. If you use `after_commit`, `after_save` or `after_commit` (basically, any callback that is called after the object is saved), you need to override the `generate_slug!` method, calling `self.save`. If you use `after_create`, the slug will only be created once, and will not reflect object updates. Other callbacks will regenerate the slug everytime the object is saved.
```ruby
before_save :generate_slug!
```
or

```ruby
after_create :generate_slug!

def generate_slug!
  super
  self.save
end
```

##Slug style
All characters except A-Z, a-z, 0-9 and dashes are removed. Multiple consecutive whitespaces are condensed to one. Spaces are then replaced with dashes. If there is already an existing slug in the current database that matches the generated slug, '-#' is appended to the slug. # represents the first nontaken slug, starting with 1.
