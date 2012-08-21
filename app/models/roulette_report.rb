class RouletteReport < ActiveRecord::Base
  # attr_accessible :title, :body

  # EVERYTHING IN THIS FILE IS WRITTEN BY VINCENT ZHU
  # He ported the videosoftware.pro flash roulette to Rails
  
  def self.report_num(ip)
    RouletteReport.where("DATE(timestamp) = '#{Date.current}'").where(:userip => ip).count
  end
  
  def self.report_num_by_name(username)
    RouletteReport.where("DATE(timestamp) = '#{Date.current}'").where("username like %#{username}%").count
  end
end
