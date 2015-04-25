class Views::Users::New < Views::Base
  needs :user

  def content
    full_row { h1 "Sign Up" }

    form_for(user) do |f|
      field(f, :name, label_text: 'Full Name') { f.text_field :name, required: true }
      field(f, :email) { f.email_field :email, required: true }
      field(f, :password) { f.password_field :password, required: true }

      full_row do
        input type: :submit, value: 'Sign Up', class: :button
      end
    end
  end

end
