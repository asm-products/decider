class Views::Proposals::Show < Views::Base
  needs :proposal, :adopt_proposal_path, :reject_proposal_path

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
          td reply.stakeholder.email
          td do
            text case reply.value
              when true then 'no objection'
              when false then 'objection'
              else 'no reply'
            end
          end
        end
      end
    end

    case proposal.adopted
      when true
        p "Proposal adopted"
      when false
        p "Proposal rejected"
      else
        div button_to('Adopt this proposal', adopt_proposal_path, method: :patch)
        div button_to('Reject this proposal', reject_proposal_path, method: :patch)
    end
  end
end
