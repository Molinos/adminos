class Admin::VersionsController < Admin::BaseController
  load_and_authorize_resource param_method: :strong_params, class: 'PaperTrail::Version'

  respond_to :xlsx

  resource PaperTrail::Version,
                    location: proc { params[:stay_in_place] ?
                                  edit_polymorphic_path([:admin, resource]) :
                                  polymorphic_path([:admin, resource.class]) }

  def index
    @versions = PaperTrail::Version.all

    respond_with do |respond|
      respond.xlsx do
        xlsx_file = ExportXlsx.new.call
        send_data xlsx_file
      end
    end
  end

  private

  alias_method :collection_orig, :collection
  def collection
    @collection ||= collection_orig.order('created_at desc')
      .page(params[:page]).per(settings.per_page)
  end
end
