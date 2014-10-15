##
# Client model:
#   id:serial
#	number:integer{2}
#   operation:string{2}
#   length:integer{2}
#   start:integer{2}
#   finish:integer{2}
#   window:string{1}
class Client < ActiveRecord::Base
  MAX_STEP = 100

  def self.produce_operations(params)
    step = params[:step].to_i
    new_client = nil
    unless params[:operation] == 'false' || params[:length] == 'false'
      length = params[:length].to_i
      operation = params[:operation]
      new_client = add_new_client(operation, length, step)
    end
    
    state = get_curr_windows_state(step)
    state[:step] = step
    state[:client] = new_client unless new_client.nil?
    state
  end
  
  private
  def self.add_new_client(operation, length, step)
    windows =
    {
      'O1' => ['a', 'c'],
      'O2' => ['a', 'b'],
      'O3' => ['b', 'c']
    }

    candidates = where(window: windows[operation]).group(:window).having('finish = max(finish)').to_a
    start = 0
    window = 'r'
    if candidates.count == 2 # Both windows are busy
      earlier_finisher = candidates.min { |a, b| a.finish <=> b.finish }
      max_step_finish = [earlier_finisher.finish, step].max
      if max_step_finish + length <= MAX_STEP
        # if window is clear now, then add new client not
        # after last served, but after current step
        start = max_step_finish + 1
        window = earlier_finisher.window
      end
    elsif candidates.count == 1 # One window is free
      start = step + 1
      window = (windows[operation] - [candidates[0].window])[0] # get free window
    else # None of the windows is busy
      start = step + 1
      window = windows[operation].sample
    end
    number = count + 1
    finish = start + length - 1
    Client.create(number: number,
                  operation: operation,
                  length: length,
                  start: start,
                  finish: finish,
                  window: window)
  end

  def self.get_curr_windows_state(step)
    where("start <= ? AND finish >= ? AND window <> 'r'", step, step).to_a.inject({ }) do |sum, client|
      sum[client.window.to_sym] = "X" + client.number.to_s + "(" + client.operation + "-" + client.length.to_s + ")"
      sum
    end
  end
end
