namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end

  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 0: Sample query; show the names of the events available")
    result = Event.select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.

    puts("Query 1: Report the total number of tickets bought by a given customer.")
    # id costumer = 1
    result1 = Customer.find_by(id: 1).tickets.count
    puts(result1)
    puts("EOQ")

    puts("Query 2: Report the total number of different events that a given customer has attended. That is,
          write a query that works for any Customer object given its model object, or the id")
    # id costumer = 1
    result2 = Event.joins(ticket_types: {:tickets => :order}).where("orders.customer_id = 1").select(:name).distinct.count
    puts(result2)
    puts("EOQ")

    puts("Query 3: Name of the events attended by a given customer")
    # id costumer = 1
    result3 = Event.joins(ticket_types: { :tickets => :order }).where("orders.customer_id = 1").select(:name).distinct.map {|x| x.name}
    puts(result3)
    puts("EOQ")

    puts("Query 4: Total number of tickets sold for an event.")
    # id event = 1
    result4 = Ticket.joins(:ticket_type => :event).where("events.id = 1").count
    puts(result4)
    puts("EOQ")

    puts("Query 5: Total sales of an event")
    # id event = 1
    result5 = TicketType.joins(:tickets, :event).where(event: 1).sum("ticket_price")
    puts(result5)
    puts("EOQ")

    puts("Query 6: The event that has been most attended by women.")
    result6 = Event.joins(ticket_types: { tickets: { :order => :customer } }).
        where("customers.gender = 'f'").group(:name).order("count(*) desc").limit(1).count
    puts(result6)
    puts("EOQ")

    puts("Query 7: The event that has been most attended by men ages 18 to 30.")
    result7 = Event.joins(ticket_types: { tickets: { :order => :customer } }).
        where("customers.gender = 'm'").where("customers.age >=18 and customers.age <=30").
        group(:name).order("count(*) desc").limit(1).count
    puts(result7)
    puts("EOQ")

    end
end