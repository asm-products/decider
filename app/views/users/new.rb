class Views::Users::New < Views::Base
  needs :user

  def content
    form_for(user) do |f|
      p do
        f.label :name
        f.text_field :name
      end

      p do
        f.label :email
        f.text_field :email
      end

      p do
        f.label :password
        f.password_field :password
      end

      input type: :submit, value: 'Sign Up'
    end
  end
end
