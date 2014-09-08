class Views::Proposals::Index < Views::Base
  needs :proposals

  def content
    p 'hi there'
    table(class: :proposals) do
      tr do
        th 'Proposer'
        th 'Description'
      end

      proposals.each do |proposal|
        tr do
          td proposal[:proposer]
          td proposal[:description]
        end
      end
    end
  end
end
