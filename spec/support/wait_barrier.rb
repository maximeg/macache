# frozen_string_literal: true

class WaitBarrier

  def initialize
    @mutex = Mutex.new
    @mutex.lock
  end

  def wait
    @mutex.lock
  end

  def unlock
    @mutex.unlock
  end

end
