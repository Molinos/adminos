![Adminos Logo](https://raw.github.com/molinos/adminos/master/adminos.png)

# Adminos

## Installation

Install initial adminos-structured files with

    $ rails g adminos:install

To add locales to installation:

    $ rails g adminos:install --locales=en,cn

Russian language is added and made the default one by default.

## Model generation

Generate adminos model with

    $ rails g adminos Model field:string body:text --type=sortable

Name, slug, published, meta_description and meta_title fields are always added.

Available model types are: default(if no type is present), section, sortable and table.

For section type, in you model must defined MAX_DEPTH constant (3 by default).

Add sorting to field:

    $ rails g adminos Model field:string:sort --type=table

Type table is required for sorting to function properly. Sorting by name is added by default.

Add search form:

    $ rails g adminos Model body:text --search=name,body

Specify the fields to search in. It is performed using pg_search gem and directed towards quick word-based search solution, but can be customized further.

If the model will be in multiple locales, you can specify which fields to translate:

    $ rails g adminos Model field:string:locale body:text:locale

To translate default fields in case no locale specific custom fields are present, add --locale option:

    $ rails g adminos Model --locale

If no need in SEO fields, switch it off using `--no-seo`.

    $ rails g adminos Model --no-seo

## Features
  ### Cropped 
  model
  ```ruby
    class User < ApplicationRecord
      include Adminos::Cropped
      
      has_one_attached :avatar
      has_one_attached :photo

      cropped :avatar
      cropped :photo
    end
  ```
  view
  ```slim
    # admin
    # aspect_ratio default 16/9
    = f.input :avatar, as: :cropp, input_html: { aspect_ratio: 2/3 }
    = f.input :photo, as: :cropp

    # public
    = image_tag object.avatar_cropped
    = image_tag object.photo_cropped
  ```

## Deploy the application

#### Prepare config files.

    $ cap staging deploy:check
    $ cap staging deploy

#### Tests

    $ rspec
