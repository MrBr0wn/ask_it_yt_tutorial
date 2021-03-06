class AnswerDecorator < ApplicationDecorator
  delegate_all

  # autodecorating related model
  decorates_association :user

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def formatted_created_at
    # output formatting with i18n
    l created_at, format: :long
  end
end
