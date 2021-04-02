require 'rest-client'
# frozen_string_literal: true

# app/controllers/travel_controller.rb
class BudaController < ApplicationController
  def index; 
    @file2 = []
    url1 = 'https://www.buda.com/api/v2/markets.json'
    @market = request_api(url1)
   @yesterday= (Time.now.to_i - 1.day.to_i)*1000
  #  puts @yesterday
    @result1=@market['markets'].each_with_index { |v, i| get_all(v['id'], i,@yesterday) }

  end

  def search
    
    @file = []
    url1 = 'https://www.buda.com/api/v2/markets.json'
    @market = request_api(url1)
   
    @market['markets'].each_with_index { |v, i| get_by_id(v['id'], i) }
  end

  private
 
  def get_by_id(id, index )
   
    url2 = "https://www.buda.com/api/v2/markets/#{id}/ticker.json"
    result2 = request_api(url2)
    @file[index]= [ id,  result2['ticker']['max_bid'][0], result2['ticker']['max_bid'][1] ]
    puts @file[index]
  end
  def get_all(id, index,day)
    url="https://www.buda.com/api/v2/markets/#{id}/trades?limit=100.json"
    req =request_api(url)
    last = req["trades"]["last_timestamp"]
    # puts day
    # puts last
    entries=req["trades"]["entries"]
    while last.to_i>day do
      puts "request"
      req =request_api("https://www.buda.com/api/v2/markets/#{id}/trades?timestamp=#{last}&limit=100.json")
      entries= entries+req["trades"]["entries"]
      last = req["trades"]["last_timestamp"]
    end
    
    entries= entries.max_by{|x| Float(x[1])*Float(x[2])}
 arr=[]
    arr[0]=id
    arr[1]=entries[0]
    arr[2]=entries[1]
    arr[3]=entries[2]
    arr[4]=entries[3]
    arr[5]= Float(entries[1])*Float(entries[2])
    @file2[index]=arr

  end
  def request_api(url)
    response = RestClient.get(url)
    JSON.parse(response.body)
  end
end
