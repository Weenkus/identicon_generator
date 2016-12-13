defmodule Identicon do

    def main(string) do
        string
        |> hash
        |> pick_color
        |> build_grid
        |> filter_odd_squares
        |> build_pixel_map
        |> draw_image
        |> save_image(string)
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
        grid = 
            hex
            |> Enum.chunk(3)
            |> Enum.map(&mirror_row/1)
            |> List.flatten
            |> Enum.with_index

        %Identicon.Image{image | grid: grid}
    end

    def mirror_row([first, second | _tail] = row) do
        row ++ [second, first]
    end

    def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
        grid = Enum.filter grid, fn({code, _index}) -> 
            rem(code, 2) == 0
        end

        %Identicon.Image{image | grid: grid}
    end

    def build_pixel_map(%Identicon.Image{grid: grid} = image) do
        pixel_map = Enum.map grid, fn({_code, index}) ->
            cell_width = 50
            grid_width = 5

            horizontal = rem(index, grid_width) * cell_width
            vertical = div(index, grid_width) * cell_width

            top_left = {horizontal, vertical}
            bottom_left = {horizontal + cell_width, vertical + cell_width}

            {top_left, bottom_left}
        end

        %Identicon.Image{image | pixel_map: pixel_map}
    end

    def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
        image = :egd.create(250, 250)
        fill = :egd.color(color)

        Enum.each pixel_map, fn({top_left, bottom_right}) ->
            :egd.filledRectangle(image, top_left, bottom_right, fill)
        end

        :egd.render(image)
    end

    def save_image(image, filename) do
        File.write("#{filename}.png", image)
    end

end
