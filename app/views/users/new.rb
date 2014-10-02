class Views::Users::New < Views::Base
  needs :user

  def content
    form_for(user) do |f|
      p do
        f.label :name
        f.text_field :name, required: true
        text f.object.errors[:name].join(', ')
      end

      p do
        f.label :email
        f.email_field :email, required: true
        text f.object.errors[:email].join(', ')
      end

      p do
        f.label :password
        f.password_field :password, required: true
        text f.object.errors[:password].join(', ')
      end

      input type: :submit, value: 'Sign Up'
    end
  end
end
