# Checking on fill at least one field

class LocaleValidator < ActiveModel::Validator
  def validate(record)
    fields = options[:fields] || [:name]

    fields.each do |field|
      validations(field, record)
    end
  end

  private

  def validations(field, record)
    validate_name = false

    I18n.available_locales.each do |locale|
      Mobility.with_locale(locale) do
        validate_name = true unless record.send(field).blank?
      end
    end

    validate_name = true if record.send(field).presence

    record.errors.add(field, 'Укажите Название хотя бы в одной локали') unless validate_name
  end
end
