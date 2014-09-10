class Views::Proposals::Show < Views::Base
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
  end
end
