class Views::UserSessions::New < Views::Base
  needs :user

  def content
    full_row { h1 "Sign In" }

    form_for(user, url: user_sessions_path, method: :post) do |f|
      field(f, :email) { f.email_field :email, required: true }
      field(f, :password) { f.password_field :password, required: true }

      full_row do
        input type: :submit, value: 'Sign In', class: :button
      end
    end
  end
end
