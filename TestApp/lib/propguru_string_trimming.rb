def get_condo_name(raw_condo_name_string)
  arr = raw_condo_name_string.split ' - '
  len = arr.length

  if (len < 2)
    return nil
  end

  joined_str = ""
  for i in 1..(len-1)
    joined_str = "#{joined_str}#{arr[i]}"
  end

  arr = joined_str.split '  ('
  len = arr.length

  if (len < 1)
    return nil
  elsif (len < 2)
    return arr[0]
  end

  joined_str = ""
  for i in 0..(len-2)
    joined_str = "#{joined_str}#{arr[i]}"
  end

  return joined_str
end

def get_agent_and_phone_number(raw_string)
  output = Hash.new
  output[:name] = nil
  output[:phone_number] = nil

  arr = raw_string.split ' by '

  if (arr.length < 2)
    return output
  end

  new_str = arr[1]

  arr2 = new_str.split " - call "

  if (arr2.length == 1)
    arr2 = new_str.split "<br>Call "
  end

  if (arr2.length < 1)
    return output
  end

  output[:name] = arr2[0]

  if (arr2.length > 1)
    output[:phone_number] = arr2[1]
  end

  return output
end

def get_price_psf(raw_string)
  arr = raw_string.split("$ ")

  if (arr.length < 2)
    return nil
  end

  joined_str = arr[1]

  arr = joined_str.split " psf"
  if (arr.length < 1)
    return nil
  end

  begin
    return Float(arr[0])
  rescue
    return nil
  end
end

def get_area(raw_string)
  arr = raw_string.split " sqft"

  if (arr.length < 1)
    return nil
  end

  area_string = arr[0]
  new_str = ""
  area_string.each_char { |c|
    if (c == ",")
      next
    end
    
    new_str = "#{new_str}#{c}"
  }

  begin
    return Integer(new_str)
  rescue
    return nil
  end
end

def get_number_of_bedrooms(raw_string)
  begin
    return Integer(raw_string)
  rescue
    return nil
  end
end

def get_number_of_pages(raw_string)
  arr = raw_string.split(" shown")
  if (arr.length < 1)
    return nil
  end

  new_str = arr[0]
  arr = new_str.split(" of ")

  if (arr.length < 1)
    return nil
  end

  output_str = arr[arr.length-1]

  begin
    return Integer(output_str)
  rescue
    return nil
  end
end