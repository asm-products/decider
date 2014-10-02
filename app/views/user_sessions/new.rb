class Views::UserSessions::New < Views::Base
  needs :user

  def content
    form_for(user, url: user_sessions_path, method: :post) do |f|
      p do
        f.label :email
        f.email_field :email, required: true
      end

      p do
        f.label :password
        f.password_field :password, required: true
      end

      input type: :submit, value: 'Sign In'
    end
  end
end
