class Views::Base < Fortitude::Widget
  doctype :html5

  def row
    div class: :row do
      yield
    end
  end

  def field(f, field)
    has_errors = f.object.errors[field].any?
    error_class = has_errors ? 'error' : ''

    row do
      div class: error_class do
        f.label field do
          text field.to_s.capitalize
          yield
        end
        if has_errors
          small f.object.errors[field].join(', '), class: :error
        end
      end
    end
  end
end
