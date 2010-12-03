def fetch_data(minprice=nil, maxprice=nil, districts=nil)

  propguru_basic_url = "http://www.propertyguru.com.sg/singapore-property-listing?listing_type=sale&property_type=N&property_type_code[]=CONDO&property_type_code[]=APT&property_type_code[]=WALK&property_type_code[]=CLUS&property_type_code[]=EXCON"

  propguru_url_after_params = propguru_basic_url

  propguru_url_after_params = "#{propguru_url_after_params}&minprice=#{minprice}" unless minprice.nil?
  propguru_url_after_params = "#{propguru_url_after_params}&maxprice=#{maxprice}" unless maxprice.nil?

  if (!districts.nil? && districts.length > 0)
    propguru_url_after_params = "#{propguru_url_after_params}&search_type=district"

    districts.each {|dis|
      propguru_url_after_params = "#{propguru_url_after_params}&districts[]=#{dis}"
    }
  end


  result = Array.new

  require 'nokogiri'
  require 'propguru_string_trimming.rb'

  number_of_pages = nil
  current_page_number = 1

  while (number_of_pages.nil? || current_page_number <= [5, number_of_pages].min)

    propguru_url = propguru_url_after_params

    if current_page_number > 1
      propguru_url = "#{propguru_url}&smm=#{current_page_number}"
    end

    propguru_response = Net::HTTP.get URI.parse(propguru_url)

    doc = Nokogiri::HTML(propguru_response)

    begin
      indicated_number_of_pages = get_number_of_pages doc.xpath("//div[@id='listinglist']").first.css('div.QAlistheader').first.css('div').first.inner_html
      number_of_pages = indicated_number_of_pages unless indicated_number_of_pages.nil?
    rescue
      if (number_of_pages.nil?)
        number_of_pages = 1
      end
    end



    listing_form = doc.xpath("//form[@id='contactmultiform']").first

    listing_form.css('div.blistingitem-new').each do |d|
      result_entry = Hash.new

      info1 = d.css('div.listinginfo1-new').first
      info2 = d.css('div.listinginfo2-new').first

      result_entry[:condo_name] = get_condo_name info1.css('div').first.css('a.bluelink-new').first.inner_html
      agent_name_phone_number = get_agent_and_phone_number info1.css('div')[3].inner_html
      result_entry[:agent_name] = agent_name_phone_number[:name]
      result_entry[:phone_number] = agent_name_phone_number[:phone_number]



      result_entry[:price_per_square_feet] = nil
      result_entry[:price_per_square_feet] = get_price_psf info2.css('div.blprice-new')[1].inner_html unless (info2.css('div.blprice-new').nil? || info2.css('div.blprice-new').length < 2)

      result_entry[:area] = nil
      result_entry[:area] = get_area info2.css('div.blprice-new')[2].inner_html unless (info2.css('div.blprice-new').nil? || info2.css('div.blprice-new').length < 3)

      result_entry[:number_of_bedrooms] = nil
      begin
        result_entry[:number_of_bedrooms] = get_number_of_bedrooms info2.css('div.listingicons-new').first.css('div.bedroomicon').first.inner_html
      rescue
        #do nothing
      end

      result.push result_entry
    end

    current_page_number = current_page_number + 1
  end


  agents = Agent.find(:all)
  agents.each { |agent|
    agent.delete
  }

  condos = Condo.find(:all)
  condos.each { |condo|
    condo.delete
  }

  result.each { |r|
    r[:agent_name] = r[:agent_name].downcase unless r[:agent_name].nil?
    r[:agent_name] = r[:agent_name].strip unless r[:agent_name].nil?

    r[:phone_number] = r[:phone_number].downcase unless r[:phone_number].nil?
    r[:phone_number] = r[:phone_number].strip unless r[:phone_number].nil?

    agent = Agent.find(:first, :conditions => ["name LIKE ? AND phone_number LIKE ?", r[:agent_name], r[:phone_number]])

    if (agent.nil?)
      agent = Agent.new
      agent.name = r[:agent_name]
      agent.phone_number = r[:phone_number]
      agent.save
    end

    new_condo = Condo.new
    new_condo.name = r[:condo_name]
    new_condo.area = r[:area]
    new_condo.number_of_bedrooms = r[:number_of_bedrooms]
    new_condo.price_per_square_feet = r[:price_per_square_feet]

    agent.condos.push new_condo

    new_condo.save
  }

end