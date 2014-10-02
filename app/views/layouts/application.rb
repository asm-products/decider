class Views::Layouts::Application < Views::Base

  def content
    html do
      head do
        title "Citizen Decider"
        stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true
        javascript_include_tag 'application', 'data-turbolinks-track' => true
        csrf_meta_tags
      end
      body do
        div class: :nav do

          if logged_in?
            ul do
              li "Welcome, #{current_user.name}"
              li link_to "Logout", logout_path, method: :post
            end
          else
            ul do
              li link_to "Sign In", login_path
              li link_to "Sign Up", new_user_path
            end
          end
        end

        yield
      end
    end
  end

end