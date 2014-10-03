class Views::Proposals::Index < Views::Base
  needs :proposals

  def content
    p(link_to 'New Proposal', new_proposal_path)

    h2 'Proposals'

    div(class: :proposals) do
      proposals.each do |proposal|
        p do
          text "#{proposal.proposer} proposed "
          text link_to(proposal.description, proposal_path(id: proposal.id))
          text " - #{proposal.status}"
        end
      end
    end
  end
end
