defmodule DemoCrawly1 do
  use Crawly.Spider
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
    item=%{
      title: document |> Floki.find("h1.film-title a") |> Floki.text(),
      link: Enum.at(document |> Floki.find("h1.film-title a") |> Floki.attribute("href"), 0),
      full_series: !String.contains?(item_infor |> Floki.find(".pre-scrollable .list.m-a-0:last-child .list-item.p-a-0:nth-of-type(1) .text-danger") |> Floki.text(),["Tập"]),
      number_of_episode: Enum.at(check_number_of_episode(item_infor |> Floki.find(".pre-scrollable .list.m-a-0:last-child .list-item.p-a-0:nth-of-type(1) .text-danger") |> Floki.text()),0),
      category: item_infor |> Floki.find(".genre-tags a:first-child") |> Floki.text(),
      years: check_image(Enum.at(document |> Floki.find(".big-poster")|> Floki.attribute("style"), 0)) |>check_year_update(),#String.replace(item_infor |> Floki.find(".pre-scrollable .list.m-a-0:last-child .list-item.p-a-0:nth-of-type(5)") |> Floki.text(),"Năm phát hành:",""),
      release_year: String.replace(item_infor |> Floki.find(".pre-scrollable .list.m-a-0:last-child .list-item.p-a-0:nth-of-type(5)") |> Floki.text(),"Năm phát hành:",""),
      thumnail: check_image(Enum.at(document |> Floki.find(".big-poster")|> Floki.attribute("style"), 0)), #String.slice(Enum.at(document |> Floki.find(".big-poster")|> Floki.attribute("style"), 0),22..-3),
    }
    %Crawly.ParsedItem{:items => [item], :requests => requests}


  end
  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()

  defp check_image(image) do
    case image do
      nil -> ""
      _ -> String.slice(image,22..-3)

    end
  end
  defp check_number_of_episode(string) do
    case string do
      nil -> 1
      _ ->String.split(string,"/")|> List.first() |> String.split(~r"[^\d]", trim: true)
    end
  end
  defp check_year_update(string) do
    case string do
      nil -> ""
      _ -> String.split(String.slice(string,40..-1) ,"/")|> List.first()

    end
  end

end
