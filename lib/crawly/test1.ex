defmodule PriceMonitoring do
  def start() do

    urls = [
      "https://phephims.net/the-loai/phim-hoat-hinh?page=1"
    ]
    Crawly.Engine.start_spider(Spider1, urls: urls, crawl_id: "123")
  end

  def stop() do
    Crawly.Engine.stop_spider(Spider1)
  end
end
