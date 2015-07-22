Rails.application.assets.context_class.class_eval do
  include ActionView::Helpers
  include AbstractController::Helpers
  include Rails.application.routes.url_helpers
  include ActionController::Helpers
end