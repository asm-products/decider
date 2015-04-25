class Views::Proposals::Index < Views::Base
  needs :proposals

  def content
    full_row { link_to 'New Proposal', new_proposal_path, class: 'button' }

    full_row { h2 'Proposals' }

    if proposals.present?
      div(id: :proposals) { render proposals }
    end
  end
end
