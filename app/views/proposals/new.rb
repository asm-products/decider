class Views::Proposals::New < Views::Base
  needs :possible_stakeholders

  def content
    form_for(:proposal, url: proposals_path, method: :post) do |f|
      p do
        label('My Name', for: 'proposer')
        input(type: :text, id: 'proposer', name: 'proposal[proposer]')
      end

      p do
        label('My Email', for: 'proposer_email')
        input(type: :text, id: 'proposer_email', name: 'proposal[proposer_email]')
      end

      h2 { label('Proposal', for: 'description') }

      p 'Example: "I propose we use Citizen Decider to make quick decisions"'

      p 'I propose:'

      p { textarea(id: 'description', name: 'proposal[description]') }

      div class: 'stakeholders' do
        f.collection_check_boxes(:user_ids, possible_stakeholders, :id, :name)
      end

      input(type: :submit, value: 'Create Proposal')
    end
  end
end
