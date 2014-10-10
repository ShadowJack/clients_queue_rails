MAX_STEP = 100           # The length of the day
max_length = 10         # Maximum length of client's task to generate
client_gen_prob = 0.5   # Probability of client to be genegated this step 
interval = null         # global interval that supports main operation utility
step = 1                # current step

# Generates client randomly
gen_client = ->
  must_generate = Math.random() < client_gen_prob
  if not must_generate
    return { operation: false, length: false }
  client = 
    operation: 'O' + Math.ceil(Math.random() * 3),
    length: Math.ceil(Math.random() * max_length)
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
    client = 'client X' + data.client.number +
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
operate = ->
  client = gen_client()
  $.post('/clients.json', 
  { operation: client.operation, length: client.length, step: step }, 
  (data) ->
    add_new_row(data) 
    step = parseInt(step, 10) + 1
    if step > MAX_STEP
      clearInterval(interval)
  )


# -----------------Execution starts here-----------------
#
# In loop generate a new client and send it to the queue
# get new info about queue state by ajax request  
$(->
  $('#sbmt').click ->
    if $('#max_length').val() != ''
      max_length = parseInt($('#max_length').val(), 10)
      console.log "Max length: ", max_length
    if $('#prob').val() != ''
      client_gen_prob = parseFloat($('#prob').val())
      console.log "Prob: ", client_gen_prob
    $.post('/clients/clean', {}, (data)->
      interval = setInterval(operate, 1000)
    )
)
