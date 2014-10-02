class Views::Shared::Nav < Views::Base
  def content
    nav class: "top-bar", 'data-topbar' => '', role: "navigation" do
      ul class: 'title-area' do
        li class: 'name' do
          h1 do
            link_to 'Decisions', root_path
          end
        end
      end

      section class: 'top-bar-section' do
        ul class: 'right' do
          if logged_in?
            li { link_to "Welcome, #{current_user.name}", '#' }
            li class: 'divider'
            li { link_to "Logout", logout_path, method: :post }
          else
            li class: 'divider'
            li { link_to "Sign In", login_path }
            li class: 'divider'
            li { link_to "Sign Up", new_user_path }
          end
        end
      end
    end
  end

end
