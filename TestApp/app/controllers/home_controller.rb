class HomeController < ApplicationController
  def index
    @has_data = false
    @has_data = true unless session[:has_data].nil?
  end

  def view
    @ordering = params[:ordering]

    order_by_command = nil
    if (@ordering == "psf")
      order_by_command = "price_per_square_feet ASC"
    elsif (@ordering == "name")
      order_by_command = "name ASC"
    end

    @agent_id = params[:agent_id]
    agent_id_int = nil
    agent = nil
    begin
      agent_id_int = Integer(@agent_id)
      agent = Agent.find(agent_id_int)
    rescue
      #do nothing
    end

    if (!agent.nil?)
      @data = Agent.condos
    else
      @data = Condo.get_all order_by_command
    end
  end

  def update
    @id = params[:id]
    condo = nil
    begin
      id_int = Integer(@id)
      condo = Condo.find(id_int)

      if (condo.nil?)
        redirect_to :controller => 'home', :action => 'index'
        return
      end
    rescue
      redirect_to :controller => 'home', :action => 'index'
      return
    end

    @name = condo.name
    @area = condo.area
    @number_of_bedrooms = condo.number_of_bedrooms
    @price_per_square_feet = condo.price_per_square_feet

    @agent_name = nil
    @agent_phone_number = nil
    if (!condo.agent.nil?)
      @agent_name = condo.aagent.name
      @agent_phone_number = condo.agent_phone_number
    end
  end

end
