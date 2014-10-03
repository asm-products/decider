class Views::Proposals::New < Views::Base
  needs :possible_stakeholders, :proposal

  def content
    row do
      h1 'Create New Proposal'
    end

    form_for(proposal) do |f|
      field(f, :description, label_text: 'I propose...') do
        f.text_area :description, required: true, placeholder: 'Example: we use Citizen Decider to make quick decisions'
      end

      row do
        label 'Stakeholders'
        div class: 'stakeholders' do
          f.collection_check_boxes(:user_ids, possible_stakeholders, :id, :name)
        end
      end

      row do
        input type: :submit, value: 'Create Proposal', class: :button
      end
    end
  end
end
