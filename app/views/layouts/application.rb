class Views::Layouts::Application < Views::Base

  def content
    html do
      head do
        meta charset: "utf-8"
        meta name: "viewport", content: "width=device-width, initial-scale=1.0"

        stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true
        javascript_include_tag 'application', 'data-turbolinks-track' => true
        javascript_include_tag 'vendor/modernizr', 'data-turbolinks-track' => true

        csrf_meta_tags

        title "Citizen Decider"
      end

      body do

        render template: 'shared/nav'

        yield

      end

    end
  end

end

