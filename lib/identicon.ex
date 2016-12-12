defmodule Identicon do

    def main(string) do
        string
        |> hash
        |> pick_color
        |> build_grid
    end

    def hash(string) do
        hex = :crypto.hash(:md5, string)
        |> :binary.bin_to_list

        %Identicon.Image{hex: hex}
    end

    def pick_color(%Identicon.Image{hex: [red, green, blue | _tail]} = image) do
        %Identicon.Image{image | color: {red, green, blue}}
    end

    def build_grid(%Identicon.Image{hex: hex} = image) do
        hex
        |> Enum.chunk(3)
        |> Enum.map(&mirror_row/1)
    end

    def mirror_row([first, second | _tail] = row) do
        row ++ [first, second]
    end

end
