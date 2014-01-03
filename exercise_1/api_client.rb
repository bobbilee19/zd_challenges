
require 'faraday'
require 'json'

class APIClient
 
  def initialize(url, email, pass)
    @connection = Faraday.new(url:url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.basic_auth(email, pass)
    end
  end
  
  def create_agent(name, email)
    users_response = @connection.post do |req|
      req.url '/api/v2/users.json'
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate({user:{name:name, email:email, verified: true, role: "agent"}})
    end
    if users_response.status == 201
      puts "User successfully created"
      JSON.parse(users_response.body)["user"]
    else
      puts users_response.body
    end
  end

  def create_ticket(name, email, submitter_id, subject, body)  
    tickets_response = @connection.post do |req|
      req.url '/api/v2/tickets.json'
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate({ticket:{requester:{name:name, email:email}, submitter_id:submitter_id, subject:subject, comment:{body:body}}})
    end
    if tickets_response.status == 201
      puts "Ticket successfully created"
    else
      puts tickets_response.body
    end
    JSON.parse(tickets_response.body)["ticket"]
  end
  
  def solve_ticket(ticket_id, assignee_id)
    solving_ticket_response = @connection.put do |req|
      req.url "/api/v2/tickets/#{ticket_id}.json"
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate({ticket:{status:"solved", assignee_id:assignee_id}})  
    end
    if solving_ticket_response.status == 200
      puts "Ticket successfully solved"
      JSON.parse(solving_ticket_response.body)["ticket"]
    else
      puts solving_ticket_response.body
    end
  end

  api_client = APIClient.new('https://hartmancompanies.zendesk.com/','bobbileehartman@gmail.com', 'test123')
  agent = api_client.create_agent("test","test@example.com")
  ticket = api_client.create_ticket(agent["name"], agent["email"], agent["id"], "Signin Error", "I am having a hard time signing in to my zendesk account")
  api_client.solve_ticket(ticket["id"], agent["id"])
end

