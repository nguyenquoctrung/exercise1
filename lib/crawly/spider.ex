defmodule Spider1 do
  use Crawly.Spider

  # This is not going to be used, so we're ignoring it.
  @impl Crawly.Spider
  def base_url() do
    :ok
  end

  @impl Crawly.Spider
  def init(options) do
    # Reading start urls from options passed from the main module
    [start_urls: Keyword.get(options, :urls)]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # First of all lets find a host, as it will allow us to match the parsing rule
    parsed_uri = URI.parse(response.request_url)
    host = parsed_uri.host

    {:ok, document} = Floki.parse_document(response.body)

    # Finally get data from the page with a mapped extractor
    item = do_parse_item(host, document) |> Map.put(:url, response.request_url)

    %{
      :requests => [],
      :items => [item]
    }
  end

  defp do_parse_item("https://phephims.net", document) do

    title= document |> Floki.find("a.film-title") |> Floki.text()
    link =  document |> Floki.find("a.film-title") |> Floki.attribute("href")
    %{name: title, price: link}
  end
end
