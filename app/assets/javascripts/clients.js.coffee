MAX_LENGTH = 20     # Maximum length of client's task to generate
MAX_STEP = 10
interval = null
step = 1

# Generates client randomly
gen_client = ->
  must_generate = Math.random() < 0.8
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
  client = if data.hasOwnProperty('client') then  'Added new client X' + data.client.id + 
                                                  ' with oper ' + data.client.operation +
                                                  ' and length of ' + data.client.length else '-'
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
