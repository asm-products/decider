class Views::Layouts::Application < Views::Base
  def content
    html doctype: :html5 do
      head do
        title "Citizen Decider"
        stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true
        javascript_include_tag 'application', 'data-turbolinks-track' => true
        csrf_meta_tags
      end
      body do
        if logged_in?
          div class: :nav do
            ul do
              li "Welcome, #{current_user.name}"
              li link_to "Logout" , logout_path
            end
          end
        end
        yield
      end
    end
  end
end
