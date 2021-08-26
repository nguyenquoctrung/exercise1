defmodule Exercise1Web.PageController do
  use Exercise1Web, :controller
   def index(conn, _params) do
    Crawly.Engine.start_spider(DemoCrawly)
    #PriceMonitoring.start()]
    render(conn, "index.html")
  end
end
