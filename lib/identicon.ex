defmodule Identicon do

    def main(string) do
        string
        |> hash
    end

    def hash(string) do
        hex = :crypto.hash(:md5, string)
        |> :binary.bin_to_list

        %Identicon.Image{hex: hex}
    end

end
