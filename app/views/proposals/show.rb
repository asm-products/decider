class Views::Proposals::Show < Views::Base
  needs :adopt_proposal_path
  needs :reject_proposal_path
  needs :proposal

  def content
    link_to 'Proposals', root_path

    p do
      b do
        text proposal.proposer
        text ' proposed '
        text proposal.description
      end
    end

    table(class: 'proposals') do
      tr do
        th 'Stakeholder'
        th 'Reply'
      end

      proposal.replies.each do |reply|
        tr do
          td reply.user_email
          td reply.value
        end
      end
    end

    if proposal.has_decision?
      p "Proposal #{proposal.status}"
    else
      div button_to('Adopt this proposal', adopt_proposal_path, method: :patch)
      div button_to('Reject this proposal', reject_proposal_path, method: :patch)
    end
  end
end
