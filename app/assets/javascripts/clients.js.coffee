MAX_LENGTH = 10     # Maximum length of client's task to generate
MAX_STEP = 50
interval = null
step = 1

# Generates client randomly
gen_client = ->
  must_generate = Math.random() < 0.5
  if not must_generate
    return { operation: false, length: false }
  client = 
    operation: 'O' + Math.ceil(Math.random() * 3),
    length: Math.ceil(Math.random() * MAX_LENGTH)

  console.log client
  return client

# Adds new row to queue table
# using data from server 
add_new_row = (data) ->
  step = data.step
  a = if data.hasOwnProperty('a') then data.a else '-'
  b = if data.hasOwnProperty('b') then data.b else '-'
  c = if data.hasOwnProperty('c') then data.c else '-'
  
  # we check if there is start and finish cause if they are eql to 0
  # then it means this client was rejected
  if data.hasOwnProperty('client')
    client = 'client X' + data.client.id +
            ' with operation ' + data.client.operation +
            ' and length of ' + data.client.length
    if data.client.start > 0
      client = 'Added new ' + client + ' to window ' + data.client.window
    else
      client = 'Rejected ' + client
  else
    client = '-'
  $new_row = $('<tr><td class="step-col">' + step +
               '</td><td class="a-col">' + a + 
               '</td><td class="b-col">' + b + 
               '</td><td class="c-col">' + c + 
               '</td><td class="client-col">' + client + 
               '</td></tr>')
  $('#status-table').append($new_row)

# Function that is executed every step
operate = (args) ->
  client = gen_client()
  $.post('/clients.json', 
  { operation: client.operation, length: client.length, step: step }, 
  (data) ->
    console.log "Got new data: ", data
    add_new_row(data) 
    step = parseInt(step) + 1
    if step > MAX_STEP
      clearInterval(interval)
  )


# --------------------Execution starts here
#
# In loop generate a new client and send it to the queue
# get new info about queue state by ajax request  
$(->
  $.post('/clients/clean', {}, (data)->
    interval = setInterval(operate, 1000)
  )
  
)
