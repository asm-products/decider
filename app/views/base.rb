class Views::Base < Fortitude::Widget
  doctype :html5

  def row
    div class: :row do
      yield
    end
  end

  def field(f, field, label_text: nil)
    has_errors = f.object.errors[field].any?
    wrapper_classes = [field.to_s]
    wrapper_classes << 'error' if has_errors

    row do
      div class: wrapper_classes do
        f.label field do
          text label_text || field.to_s.capitalize
          yield
        end
        if has_errors
          small f.object.errors[field].join(', '), class: :error
        end
      end
    end
  end
end
