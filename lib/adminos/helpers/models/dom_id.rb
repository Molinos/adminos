# <http://stackoverflow.com/questions/1183506/make-blank-params-nil#1186265>.
module Adminos::DomId
  extend ActiveSupport::Concern

  module ClassMethods
    def with_dom_id(*args)
      options = args.extract_options!
      identifier_method = options.delete(:identifier_method) || :id

      define_method :dom_id do
        @dom_id ||= [ self.class.name.pathalize,
                      self.send(identifier_method).to_s.gsub('-', '_') ].join('_')
      end
    end
  end
end
