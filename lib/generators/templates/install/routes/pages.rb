
  begin
    Page.for_routes.group_by(&:behavior).each do |behavior, pages|
      pages.each do |page|
        case behavior
        when nil
        else
          resource( "#{page.class.name.underscore}_#{page.id}",
                    path:       page.absolute_path,
                    controller: behavior,
                    only:       :show,
                    page_id:    page.id )
        end
      end
    end
  rescue
    nil
  end
