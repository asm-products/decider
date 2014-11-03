class Views::Proposals::Index < Views::Base
  needs :proposals

  def content
    row do
      columns do
        link_to 'New Proposal', new_proposal_path, class: 'button'
      end
    end

    row do
      columns do
        h2 'Proposals'
      end
    end

    div(class: :proposals) do
      proposals.each do |proposal|
        row(class: :proposal) do
          columns(1) do
            span proposal.status, class: :label
          end

          columns(11) do
            text "#{proposal.proposer} proposed "
            link_to(proposal.description, proposal_path(id: proposal.id))
          end
        end
      end
    end
  end
end
