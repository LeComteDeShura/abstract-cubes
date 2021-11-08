require_relative './state'

class Context
  attr_accessor :state

  # private :state

  def initialize(state)
    transition_to(state)
  end

  def transition_to(state)
    # puts "Context: Transition to #{state.class}"
    @state = state
    @state.context = self
  end

  def do
    @state.do
  end

  def next
    @state.next
  end
end
