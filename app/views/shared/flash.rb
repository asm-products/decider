class Views::Shared::Flash < Views::Base
  def content
    flash.each do |name, msg|
      div msg, class: "flash-#{name} alert-box alert", "data-alert" => "" if msg.is_a? String
    end
  end
end
