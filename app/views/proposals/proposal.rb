class Views::Proposals::Proposal < Views::Base
  needs :proposal

  def content
    full_row(class: :proposal) do
      title(proposal)
      details(proposal)
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
