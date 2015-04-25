class Views::Proposals::Show < Views::Base
  needs :adopt_proposal_path
  needs :reject_proposal_path
  needs :proposal
  needs :show_actions

  def content
    full_row do
      ul(class: :breadcrumbs) do
        li { link_to 'Proposals', root_path }
        li(class: :current) { link_to proposal.description.truncate(50), '#' }
      end
    end

    render proposal

    full_row do
      table(class: 'replies', style: 'margin-top: 1rem') do
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
    end

    if show_actions && !proposal.has_decision?
      full_row do
        ul class: 'button-group radius' do
          li { link_to('Adopt', adopt_proposal_path, method: :patch, class: :button) }
          li { link_to('Reject', reject_proposal_path, method: :patch, class: :button) }
        end
      end
    end
  end
end
