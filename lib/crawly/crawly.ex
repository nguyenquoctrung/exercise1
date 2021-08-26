defmodule DemoCrawly do
  use Crawly.Spider
  alias Crawly.Utils
  @impl Crawly.Spider

  def base_url(), do: "https://phephims.net"

  @impl Crawly.Spider
  def init(), do: [start_urls: ["https://phephims.net/the-loai/phim-hoat-hinh?page=1"]]

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    urls = document |> Floki.find("a.film-cover") |> Floki.attribute("href")

    pagination_urls =
      document |> Floki.find(".pagination a") |> Floki.attribute("href")

    requests =
      (urls ++ pagination_urls)
      |> Enum.uniq()
      |> Enum.map(&build_absolute_url/1)
      |> Enum.map(&Crawly.Utils.request_from_url/1)


    item_infor= document |> Floki.find("#show-detailsxx")

    item = %{
      title: document |> Floki.find("h1.film-title a") |> Floki.text(),
      link: Enum.at(document |> Floki.find("h1.film-title a") |> Floki.attribute("href"), 0),
      full_series: !String.contains?(item_infor |> Floki.find(".pre-scrollable .list.m-a-0:last-child .list-item.p-a-0:nth-of-type(1) .text-danger") |> Floki.text(),["Tập"]),
      number_of_episode: item_infor |> Floki.find(".pre-scrollable .list.m-a-0:last-child .list-item.p-a-0:nth-of-type(1) .text-danger") |> Floki.text()|> String.replace(~r/[^\d]/, ""),
      category: item_infor |> Floki.find(".genre-tags a:first-child") |> Floki.text(),
      years: String.replace(item_infor |> Floki.find(".pre-scrollable .list.m-a-0:last-child .list-item.p-a-0:nth-of-type(5)") |> Floki.text(),"Năm phát hành:",""),
      thumnail: Enum.at(document |> Floki.find(".big-poster")|> Floki.attribute("style"), 0), #String.slice(Enum.at(document |> Floki.find(".big-poster")|> Floki.attribute("style"), 0),22..-3),
      #url: response.request_url
    }


    %Crawly.ParsedItem{:items => [item], :requests => requests}

  end
  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
end
