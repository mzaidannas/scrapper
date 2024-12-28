class NewsCountOverTime < Avo::Dashboards::ChartkickCard
  self.id = "news_count_over_time"
  self.label = "News count over time"
  self.chart_type = :area_chart
  # self.description = "Some tiny description"
  self.cols = 2
  # self.initial_range = 30
  # self.ranges = {
  #   "7 days": 7,
  #   "30 days": 30,
  #   "60 days": 60,
  #   "365 days": 365,
  #   Today: "TODAY",
  #   "Month to date": "MTD",
  #   "Quarter to date": "QTD",
  #   "Year to date": "YTD",
  #   All: "ALL",
  # }
  # self.chart_options = { library: { plugins: { legend: { display: true } } } }
  # self.flush = true

  def query
    result [
      {name: "Hourly", data: ScrapedNews.where(datetime: 16.hours.ago.beginning_of_hour..).group("date_trunc('hour', datetime)").count},
      {name: "Daily", data: ScrapedNews.where(datetime: 16.days.ago.beginning_of_day..).group("date_trunc('day', datetime)").count},
      {name: "Monthly", data: ScrapedNews.where(datetime: 16.months.ago.beginning_of_month..).group("date_trunc('month', datetime)").count}
    ]
  end
end
