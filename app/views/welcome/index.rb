class Views::Welcome::Index < Views::Base
  def content
    row do
      h2 'Making decisions easier'
    end

    row do
      p 'To get started, click "Sign In" or "Sign Up" above'
    end
  end
end
