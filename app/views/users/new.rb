class Views::Users::New < Views::Base
  needs :user

  def content
    row do
      h1 "Sign Up"
    end

    form_for(user) do |f|
      field(f, :name) { f.text_field :name, required: true }
      field(f, :email) { f.email_field :email, required: true }
      field(f, :password) { f.password_field :password, required: true }

      row do
        input type: :submit, value: 'Sign Up', class: :button
      end
    end
  end

end
