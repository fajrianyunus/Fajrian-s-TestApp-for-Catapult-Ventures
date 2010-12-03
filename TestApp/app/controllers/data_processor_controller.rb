class DataProcessorController < ApplicationController
  verify :method => :post, :only => [:fetch, :create, :update, :delete], :render => {:text => '405 HTTP POST required', :status => 405}


  def fetch
    @minprice = params[:minprice]
    @maxprice = params[:maxprice]
    @districts = params[:districts]

    begin
      @minprice = Integer(@minprice)
    rescue
      @minprice = nil
    end

    begin
      @maxprice = Integer(@maxprice)
    rescue
      @maxprice = nil
    end

    list_of_districts_candidate = Array.new

    @districts.each { |key, value|
      list_of_districts_candidate.push key.to_s
    }

    require 'propguru_call.rb'
    session[:has_data] = nil
    fetch_data(@minprice, @maxprice, list_of_districts_candidate)

    session[:has_data] = true
    redirect_to :controller => 'home', :action => 'index'
  end

  def create

    @name = params[:name]
    @name = nil if (!@name.nil? && @name.strip.length == 0)

    @area = params[:area]
    @area = nil if (!@area.nil? && @area.strip.length == 0)
    begin
      @area = Integer(@area) unless @area.nil?
    rescue
      redirect_to :controller => 'home', :action => 'index'
      return
    end

    @number_of_bedrooms = params[:number_of_bedrooms]
    @number_of_bedrooms = nil if (!@number_of_bedrooms.nil? && @number_of_bedrooms.strip.length == 0)
    begin
      @number_of_bedrooms = Integer(@number_of_bedrooms) unless @number_of_bedrooms.nil?
    rescue
      redirect_to :controller => 'home', :action => 'index'
      return
    end

    @price_per_square_feet = params[:price_per_square_feet]
    @price_per_square_feet = nil if (!@price_per_square_feet.nil? && @price_per_square_feet.strip.length == 0)
    begin
      @price_per_square_feet = Float(@price_per_square_feet) unless @price_per_square_feet.nil?
    rescue
      redirect_to :controller => 'home', :action => 'index'
      return
    end

    @agent = params[:agent]
    @agent[:name] = nil if (!@agent[:name].nil? && @agent[:name].strip.length == 0)
    @agent[:name] = @agent[:name].downcase unless @agent[:name].nil?
    @agent[:phone_number] = nil if (!@agent[:phone_number].nil? && @agent[:phone_number].strip.length == 0)
    @agent[:phone_number] = @agent[:phone_number].downcase unless @agent[:phone_number].nil?

    same_agent = Agent.find(:first, :conditions => ['name LIKE ? AND phone_number LIKE ?', @agent[:name], @agent[:phone_number]])
    agent = nil
    if (same_agent.nil?)
      agent = Agent.new
      agent.name = @agent[:name]
      agent.phone_number = @agent[:phone_number]
      agent.save
    else
      agent = same_agent
    end

    condo = Condo.new
    condo.name = @name
    condo.area = @area
    condo.number_of_bedrooms = @number_of_bedrooms
    condo.price_per_square_feet = @price_per_square_feet
    condo.agent = agent
    condo.save

    redirect_to :controller => 'home', :action => 'index'
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

    @name = params[:name]
    @name = nil if (!@name.nil? && @name.strip.length == 0)

    @area = params[:area]
    @area = nil if (!@area.nil? && @area.strip.length == 0)
    begin
      @area = Integer(@area) unless @area.nil?
    rescue
      redirect_to :controller => 'home', :action => 'index'
      return
    end

    @number_of_bedrooms = params[:number_of_bedrooms]
    @number_of_bedrooms = nil if (!@number_of_bedrooms.nil? && @number_of_bedrooms.strip.length == 0)
    begin
      @number_of_bedrooms = Integer(@number_of_bedrooms) unless @number_of_bedrooms.nil?
    rescue
      redirect_to :controller => 'home', :action => 'index'
      return
    end

    @price_per_square_feet = params[:price_per_square_feet]
    @price_per_square_feet = nil if (!@price_per_square_feet.nil? && @price_per_square_feet.strip.length == 0)
    begin
      @price_per_square_feet = Float(@price_per_square_feet) unless @price_per_square_feet.nil?
    rescue
      redirect_to :controller => 'home', :action => 'index'
      return
    end

    @agent = params[:agent]
    @agent[:name] = nil if (!@agent[:name].nil? && @agent[:name].strip.length == 0)
    @agent[:name] = @agent[:name].downcase unless @agent[:name].nil?
    @agent[:phone_number] = nil if (!@agent[:phone_number].nil? && @agent[:phone_number].strip.length == 0)
    @agent[:phone_number] = @agent[:phone_number].downcase unless @agent[:phone_number].nil?

    same_agent = Agent.find(:first, :conditions => ['name LIKE ? AND phone_number LIKE ?', @agent[:name], @agent[:phone_number]])
    if (same_agent.nil?)
      agent = condo.agent

      agent = Agent.new if agent.nil?
      agent.name = @agent[:name]
      agent.phone_number = @agent[:phone_number]
      agent.save
    else
      old_agent = condo.agent
      condo.agent = same_agent
      if (old_agent.condos.length == 0)
        old_agent.delete
      end
    end

    redirect_to :controller => 'home', :action => 'index'
  end

  def delete
    if (Condo.delete_a_tuple params[:id])
      redirect_to :controller => 'home', :action => 'view'
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

end
