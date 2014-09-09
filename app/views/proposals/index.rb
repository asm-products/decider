class Views::Proposals::Index < Views::Base
  needs :proposals

  def content
    p(link_to 'New Proposal', new_proposal_path)

    table(class: :proposals) do
      tr do
        th 'Proposer'
        th 'Proposal'
        th 'Stakeholders'
      end

      proposals.each do |proposal|
        tr do
          td proposal[:proposer]
          td proposal[:description]
          td proposal[:stakeholder_emails].join(', ')
        end
      end
    end
  end
end
