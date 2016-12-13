defmodule Identicon do
  @moduledoc """
    Builds a identicon from an input string. An Identicon is a visual representation of a 
    hash value, usually of an IP address, that serves to identify a user of a computer
    system as a form of avatar while protecting the users' privacy. The original
    Identicon was a 9-block graphic, and the representation has been extended to other
    graphic forms by third parties.

    This module generates a 250x250 identicon, where 50x50 is a dimension of a cell.


    ## Examples
    
        iex> Identicon.create("Joe")
        iex> :ok

    """

    @doc """
    Creates an identicon png image from an input string. The filename of the image is equal
    to the input string.
    """
    def create(string) do
        string
            |> hash
            |> pick_color
            |> build_grid
            |> filter_odd_squares
            |> build_pixel_map
            |> draw_image
            |> save_image(string)
    end

    @doc """
      Returns a MD5 hash of a string.
    """
    def hash(string) do
        hex = :crypto.hash(:md5, string)
        |> :binary.bin_to_list

        %Identicon.Image{hex: hex}
    end

    @doc """
      Creates a image struct with RGB values from the MD5 hash (input).
      Red is the first, green the second and blue the third btye in the MD5 hash.
    """
    def pick_color(%Identicon.Image{hex: [red, green, blue | _tail]} = image) do
        %Identicon.Image{image | color: {red, green, blue}}
    end

    @doc """
      Creates a image struct with grid value from MD5 hash (input).
    """
    def build_grid(%Identicon.Image{hex: hex} = image) do
        grid = 
            hex
            |> Enum.chunk(3)
            |> Enum.map(&mirror_row/1)
            |> List.flatten
            |> Enum.with_index

        %Identicon.Image{image | grid: grid}
    end

  @doc """
    Mirror a list around its middle value.

    ## Examples
    
        iex> Identicon.mirror_row([42, 23, 22])
        [42, 23, 22, 23, 42]
 
    """
    def mirror_row([first, second | _tail] = row) do
        row ++ [second, first]
    end

    @doc """
      Return an image struct where the grid only has even values.
    """
    def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
        grid = Enum.filter grid, fn({code, _index}) -> 
            rem(code, 2) == 0
        end

        %Identicon.Image{image | grid: grid}
    end

    @doc """
      Build a pixel map for the identicon. Each cell is represented by
      top left and bottom right corners (touple). The function returns 
      all tuples needed to create the identicon image.
    """
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

    @doc """
      Uses the Image struct to draw the identicon in png format with EGD
      (Erlang Graphical Drawer). Check the official documentation for more
      information (http://erlang.org/doc/man/egd.html).
    """
    def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
        image = :egd.create(250, 250)
        fill = :egd.color(color)

        Enum.each pixel_map, fn({top_left, bottom_right}) ->
            :egd.filledRectangle(image, top_left, bottom_right, fill)
        end

        :egd.render(image)
    end

    @doc """
      Takes an Image struct and a filename and saves the image in a png format.
    """
    def save_image(image, filename) do
        File.write("#{filename}.png", image)
    end

end
