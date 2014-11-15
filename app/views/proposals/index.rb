class Views::Proposals::Index < Views::Base
  needs :proposals

  def content
    full_row { link_to 'New Proposal', new_proposal_path, class: 'button' }

    full_row { h2 'Proposals' }

    full_row { hr }

    div(class: :proposals) do
      proposals.each do |proposal|
        full_row(class: :proposal) do
          title(proposal)
          details(proposal)
        end

        full_row { hr }
      end
    end
  end

  private

  def title(proposal)
    full_row(class: :proposal_title) do
      link_to(proposal.description, proposal_path(id: proposal.id))
    end
  end

  def details(proposal)
    full_row(class: :proposal_details) do
      span proposal.status, class: [:label, :radius, { 'Adopted' => :success, 'Rejected' => :alert }[proposal.status]]
      span(class: [:muted, :smaller]) do
        text " Proposed by "
        b proposal.proposer
        text " #{time_ago_in_words(proposal.proposed_at)} ago"
      end
    end
  end
end
