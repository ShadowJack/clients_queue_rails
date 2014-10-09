##
# Client model:
#   id:serial
#   operation:string{2}
#   length:integer{2}
#   start:integer{2}
#   finish:integer{2}
#   window:string{1}
class Client < ActiveRecord::Base
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
    candidates = where(window: windows[operation]).group(:window).having("finish = max(finish)").to_a
    if (candidates.count == 0) # None of the windows is busy
      Client.create(operation: operation,
                    length: length,
                    start: (step + 1),
                    finish: (step + length),
                    window: windows[operation].sample)
    elsif (candidates.count == 1) # One window is free
      window = (windows[operation] - [candidates[0].window])[0] # get free window
      Client.create(operation: operation,
                    length: length,
                    start: (step + 1),
                    finish: (step + length),
                    window: window)
    else                          # Enqueue client
      earlier_finisher = candidates.min { |a, b| a.finish <=> b.finish }
      Client.create(operation: operation,
                    length: length,
                    start: (earlier_finisher.finish + 1),
                    finish: (earlier_finisher.finish + length),
                    window: earlier_finisher.window)
    end
  end
   
  def self.get_curr_windows_state(step)
    where("start <= ? AND finish >= ? ", step, step).to_a.inject({ }) do |sum, client|
      sum[client.window.to_sym] = "X" + client.id.to_s + "(" + client.operation + "-" + client.length.to_s + ")"
      sum
    end
  end
end
