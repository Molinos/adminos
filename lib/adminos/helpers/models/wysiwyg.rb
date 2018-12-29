module Adminos::Wysiwyg
  extend ActiveSupport::Concern
  mattr_accessor :default, :strict, :strip_tags

  @@default = \
    {
      elements: %w[
          a b blockquote br caption dd dl
          dt em h1 h2 h3 h4 h5 h6 hr i iframe img li
          ol p s small span strike strong sub sup table tbody td
          tfoot th thead tr u ul div map area section article noscript param object video source
        ],

      attributes: {
        :all         => ['lang', 'title', 'class', 'style', 'id', 'data-speed', 'data-delay', 'data-src', 'data-screenwidth', 'data-alt'],
        'a'          => ['href', 'target', 'name'],
        'img'        => ['alt', 'height', 'src', 'width', 'usemap'],
        'ol'         => ['start'],
        'td'         => ['colspan', 'rowspan'],
        'th'         => ['colspan', 'rowspan'],
        'iframe'     => ['title', 'type', 'width', 'height', 'src', 'frameborder', 'allowFullScreen'],
        'map'        => ['name'],
        'area'       => ['shape', 'href', 'class', 'coords', 'alt'],
        'object'     => ['data', 'type', 'width', 'height'],
        'param'      => ['name', 'value'],
        'video'      => ['autoplay', 'controls', 'width', 'height', 'loop', 'poster'],
        'source'     => ['src', 'type']
      },

      protocols: {
        'a'          => { 'href' => ['ftp', 'http', 'https', 'mailto', :relative] },
        'blockquote' => { 'cite' => ['http', 'https', :relative] },
        'del'        => { 'cite' => ['http', 'https', :relative] },
        'img'        => { 'src'  => ['http', 'https', :relative] },
        'ins'        => { 'cite' => ['http', 'https', :relative] },
        'q'          => { 'cite' => ['http', 'https', :relative] }
      },

      remove_contents: %w(style)
    }

  @@strict = \
   {
      elements: %w[
          p h2 h3 h4 blockquote a b strong i em br hr iframe img ul ol li span sub sup
        ],

      attributes: {
        :all         => ['lang', 'title'],
        'a'          => ['href', 'target'],
        'img'        => ['alt', 'height', 'src', 'width', 'style'],
        'ol'         => ['start'],
        'p'          => [],
        'iframe'     => ['type', 'width', 'height', 'src', 'frameborder', 'allowFullScreen']
      },

      protocols: {
        'a'          => { 'href' => ['ftp', 'http', 'https', 'mailto', :relative] },
        'blockquote' => { 'cite' => ['http', 'https', :relative] },
        'del'        => { 'cite' => ['http', 'https', :relative] },
        'img'        => { 'src'  => ['http', 'https', :relative] },
        'ins'        => { 'cite' => ['http', 'https', :relative] },
        'q'          => { 'cite' => ['http', 'https', :relative] }
      },

      remove_contents: %w(style)
    }

  @@strip_tags = { elements: nil }

  module ClassMethods
    def wysiwyg_sanitize(*args)
      options = args.extract_options!
      config = options.delete(:kind) || :default
      kaya_content = options.delete(:kaya_content)

      before_validation do
        args.each do |f|
          if kaya_content
            self[f] = self.class.wysiwyg_clean_kaya self[f], send(config)
          else
            self[f] = self.class.wysiwyg_clean self[f], send(config)
          end
        end
      end
    end

    def wysiwyg_clean_kaya(data, config)
      kaya_data = JSON.parse(data)
      kaya_data.map! do |block|
        if block['type'] == 'text'
          block['data']['text'] = wysiwyg_clean block['data']['text'], config
        end
        block
      end
      kaya_data.to_json
    end

    def wysiwyg_clean(text, config)
      res = Sanitize.clean text, config
      res = res.gsub(/^<br\s*(\/?)>\s*$/im, '') unless res.nil?
      res
    end
  end
end
