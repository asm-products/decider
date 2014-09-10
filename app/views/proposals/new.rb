class Views::Proposals::New < Views::Base
  needs :proposal

  def content
    form_for(:proposal, url: proposals_path, method: :post) do
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

      p { textarea(id: 'description', name: 'proposal[description]') }

      h2 { label('Stakeholders', for: 'stakeholder_emails') }

      p 'Email addresses separated by spaces'

      p do
        textarea(id: 'stakeholder_emails', name: 'proposal[stakeholder_emails]')
      end

      input(type: :submit, value: 'Create Proposal')
    end
  end
end
