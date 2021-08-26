defmodule Paging do
  def base_url(), do: "https://phephims.net"
  def fetch(url) do
    response = Crawly.fetch(url)

    data = parse_item(response)
    data
  end
  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
  defp parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    urls = document |> Floki.find("a.d-block") |> Floki.attribute("href")

    pagination_urls =
      document |> Floki.find(".pagination a") |> Floki.attribute("href")

    requests =
      (urls ++ pagination_urls)
      |> Enum.uniq()
      |> Enum.map(&build_absolute_url/1)
      |> Enum.map(&Crawly.Utils.request_from_url/1)


    page = String.replace(response.request_url,"https://phephims.net/the-loai/phim-hoat-hinh?page=","")
   %{
      :requests => requests,
      :items => Enum.sort([%{page: page, url: response.request_url}], &(&1.page < &2.page))
    }


  end

end




#   use Crawly.Spider
#   alias Crawly.Utils
#   @impl Crawly.Spider

#   def base_url(), do: "https://phephims.net"

#   @impl Crawly.Spider
#   def init(), do: [start_urls: ["https://phephims.net/the-loai/phim-hoat-hinh?page=1"]]

#   @impl Crawly.Spider
#   def parse_item(response) do
#     {:ok, document} = Floki.parse_document(response.body)

#     urls = document |> Floki.find("a.d-block") |> Floki.attribute("href")

#     pagination_urls =
#       document |> Floki.find(".pagination a") |> Floki.attribute("href")

#     requests =
#       (urls ++ pagination_urls)
#       |> Enum.uniq()
#       |> Enum.map(&build_absolute_url/1)
#       |> Enum.map(&Crawly.Utils.request_from_url/1)


#     page = String.replace(response.request_url,"https://phephims.net/the-loai/phim-hoat-hinh?page=","")

#     %{
#       :requests => requests,
#       :items => [%{page: page, url: response.request_url}]
#     }
#     fn item ->
#       %{
#         :requests => requests,
#         :items => [%{page: page, url: response.request_url}]
#       }
#     end

#   end
#   defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
# end
