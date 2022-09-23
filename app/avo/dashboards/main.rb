class Main < Avo::Dashboards::BaseDashboard
  self.id = "main"
  self.name = "Main"
  # self.description = "Tiny dashboard description"
  # self.grid_cols = 3
  # self.visible = -> do
  #   true
  # end

  # cards go here
  card NewsCount
  card NewsCountOverTime
end
