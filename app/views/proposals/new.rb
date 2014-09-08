class Views::Proposals::New < Views::Base
  needs :proposal

  def content
    form_for(:proposal, url: proposals_path, method: :post) do
      p do
        label('Proposer', for: 'proposer')
        input(type: :text, id: 'proposer', name: 'proposal[proposer]')
      end

      p do
        label('Proposal', for: 'description')
        textarea(id: 'description', name: 'proposal[description]')
      end

      input(type: :submit, value: 'Create Proposal')
    end
  end
end
