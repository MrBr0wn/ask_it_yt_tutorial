class CommentDecorator < ApplicationDecorator
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

  # For what comment(Question or Answer)
  def for?(commentable)
    # if commentable already was decorate, then
    # extract source object
    commentable = commentable.object if commentable.decorated?

    # getting concrete class
    commentable == self.commentable
  end
end
