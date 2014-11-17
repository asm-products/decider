class Views::Base < Fortitude::Widget
  doctype :html5

  def row(div_options={})
    div_class = ([:row] << div_options[:class]).compact
    div class: div_class  do
      yield
    end
  end

  def columns(small=12)
    div class: "small-#{small} columns" do
      yield
    end
  end

  def full_row(div_options={})
    row(div_options) do
      columns do
        yield
      end
    end
  end

  def field(f, field, label_text: nil)
    has_errors = f.object.errors[field].any?
    wrapper_classes = ['small-12', 'columns', field.to_s]
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
