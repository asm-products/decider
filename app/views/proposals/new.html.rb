class Views::Proposals::New < Views::Base
  needs :proposal

  def content
    form_for(:proposal, url: proposals_path, method: :post) do
      input(type: :text, name: 'proposal[proposer]')
      input(type: :text, name: 'proposal[description]')
      input(type: :submit, value: 'Create Proposal')
    end
  end
end
