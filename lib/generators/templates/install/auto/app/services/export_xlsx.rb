class ExportXlsx
  include SpreadsheetArchitect

  def initialize
    @versions = PaperTrail::Version.all
  end

  def call
    generate_xlsx
  end

  private

  def generate_xlsx
    headers = [
      'Объект',
      'Тип',
      'Событие',
      'Пользователь',
      'Дата',
      'Изменения'
    ]

    data = @versions.map do |x|
      next if x.item_type.safe_constantize.blank? || x.item.blank?
      [
        x.item.name,
        x.item_type,
        x.event,
        x.whodunnit,
        x.created_at.strftime('%Y-%m-%d'),
        YAML.load(x.object_changes)
      ]
    end
    data = data.compact

    header_style = {
      background_color: '000000',
      color: 'FFFFFF',
      font_name: 'Arial',
      font_size: 12,
      align: {
        horizontal: :center,
        vertical: :center,
        wrap_text: true
      }
    }

    borders = [
      {
        range: { rows: :all, columns: :all },
        border_styles: {
          edges: [:top, :bottom, :left, :right],
          style: :medium,
          color: '000000'
        }
      }
    ]

    column_styles = [
      {
        columns: (1..4),
        styles:
        { align: { horizontal: :center, vertical: :center, wrap_text: true } }
      }
    ]

    SpreadsheetArchitect.to_xlsx(
      headers: headers,
      data: data,
      header_style: header_style,
      borders: borders,
      column_styles: column_styles
    )
  end
end
