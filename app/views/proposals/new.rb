class Views::Proposals::New < Views::Base
  needs :possible_stakeholders, :proposal

  def content
    full_row { h1 'Create New Proposal' }

    form_for(proposal) do |f|
      field(f, :description, label_text: 'I propose...') do
        f.text_area :description, required: true, placeholder: 'Example: we use Citizen Decider to make quick decisions'
      end

      full_row do
        label 'Stakeholders'
        div class: 'stakeholders' do
          f.collection_check_boxes(:user_ids, possible_stakeholders, :id, :name)
        end
      end

      full_row do
        input type: :submit, value: 'Create Proposal', class: :button
      end
    end
  end
end
