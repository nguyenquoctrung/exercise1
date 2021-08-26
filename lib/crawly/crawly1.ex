defmodule EslSpider do
  use Crawly.Spider
  alias Crawly.Utils
  @impl Crawly.Spider
  def base_url(), do: "https://phephims.net"
  @impl Crawly.Spider
  def init(), do: [start_urls: ["https://phephims.net/the-loai/phim-hoat-hinh"]]
  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)
    hrefs = document |> Floki.find(".film-title") |> Floki.attribute("href")
    requests =
      Utils.build_absolute_urls(hrefs, base_url())
      |> Utils.requests_from_urls()
    title = document |> Floki.find("film-title") |> Floki.text()
    %{
      :requests => requests,
      :items => [%{title: title, url: response.request_url}]
    }
  end
end
