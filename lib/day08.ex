defmodule Day08 do
  @moduledoc """
  --- Day 8: Space Image Format ---
  """

  @doc """
  --- Part One ---

  The Elves' spirits are lifted when they realize you have an opportunity to
  reboot one of their Mars rovers, and so they are curious if you would spend
  a brief sojourn on Mars. You land your ship near the rover.

  When you reach the rover, you discover that it's already in the process of
  rebooting! It's just waiting for someone to enter a BIOS password. The Elf
  responsible for the rover takes a picture of the password (your puzzle
  input) and sends it to you via the Digital Sending Network.

  Unfortunately, images sent via the Digital Sending Network aren't encoded
  with any normal encoding; instead, they're encoded in a special Space Image
  Format. None of the Elves seem to remember why this is the case. They send
  you the instructions to decode it.

  Images are sent as a series of digits that each represent the color of a
  single pixel. The digits fill each row of the image left-to-right, then
  move downward to the next row, filling rows top-to-bottom until every pixel
  of the image is filled.

  Each image actually consists of a series of identically-sized layers that
  are filled in this way. So, the first digit corresponds to the top-left
  pixel of the first layer, the second digit corresponds to the pixel to the
  right of that on the same layer, and so on until the last digit, which
  corresponds to the bottom-right pixel of the last layer.

  For example, given an image 3 pixels wide and 2 pixels tall, the image data
  123456789012 corresponds to the following image layers:

  Layer 1: 123
           456

  Layer 2: 789
           012

  The image you received is 25 pixels wide and 6 pixels tall.

  To make sure the image wasn't corrupted during transmission, the Elves
  would like you to find the layer that contains the fewest 0 digits. On that
  layer, what is the number of 1 digits multiplied by the number of 2 digits?

  Your puzzle answer was 2520.
  """

  def process_image_1 do
    get_image()
    |> Enum.chunk_every(25 * 6)
    |> Enum.map(fn layer ->
      Enum.reduce(layer, {0, 0, 0}, fn pixel, {zeros, ones, twos} ->
        case pixel do
          ?0 -> {zeros + 1, ones, twos}
          ?1 -> {zeros, ones + 1, twos}
          ?2 -> {zeros, ones, twos + 1}
        end
      end)
    end)
    |> Enum.reduce({999, 0}, fn {zeros, ones, twos}, {min_zeros, ones_times_twos} ->
      if zeros < min_zeros do
        {zeros, ones * twos}
      else
        {min_zeros, ones_times_twos}
      end
    end)
    |> elem(1)
  end

  @doc """
  --- Part Two ---

  Now you're ready to decode the image. The image is rendered by stacking the
  layers and aligning the pixels with the same positions in each layer. The
  digits indicate the color of the corresponding pixel: 0 is black, 1 is
  white, and 2 is transparent.

  The layers are rendered with the first layer in front and the last layer in
  back. So, if a given position has a transparent pixel in the first and
  second layers, a black pixel in the third layer, and a white pixel in the
  fourth layer, the final image would have a black pixel at that position.

  For example, given an image 2 pixels wide and 2 pixels tall, the image data
  0222112222120000 corresponds to the following image layers:

  Layer 1: 02
           22

  Layer 2: 11
           22

  Layer 3: 22
           12

  Layer 4: 00
           00

  Then, the full image can be found by determining the top visible pixel in
  each position:

    - The top-left pixel is black because the top layer is 0.
    - The top-right pixel is white because the top layer is 2 (transparent),
      but the second layer is 1.
    - The bottom-left pixel is white because the top two layers are 2, but
      the third layer is 1.
    - The bottom-right pixel is black because the only visible pixel in that
      position is 0 (from layer 4).

  So, the final image looks like this:

  01
  10

  What message is produced after decoding your image?

  Your puzzle answer was LEGJY.
  """

  def decode_image do
    get_image()
    # Each image layer is (25 * 6) 150 pixels long
    |> find_visible_pixels(0, [])
    # Make the letters in the image easier to read
    |> Enum.map(fn pixel ->
      case pixel do
        ?1 -> ?*
        ?0 -> ?\s
      end
    end)
    # Each line of the image is 25 pixels long
    |> Enum.chunk_every(25)
    |> Enum.each(&IO.puts("#{inspect(&1)}"))

    # We see these letters in the image
    "LEGJY"
  end

  defp find_visible_pixels(_image, 150, pixels), do: Enum.reverse(pixels)

  defp find_visible_pixels(image, nth_pixel, pixels) do
    # Each layer is 150 pixels long,
    # so every 150 pixels is a pixel in a layer below the current top pixel
    pixel =
      Enum.take_every(image, 150)
      # The first pixel that isn't '2' is the visible pixel
      |> Enum.find(&(&1 != ?2))

    find_visible_pixels(tl(image), nth_pixel + 1, [pixel | pixels])
  end

  # common functions

  defp get_image(input \\ "inputs/day08_input.txt") do
    File.read!(input)
    |> String.to_charlist()
  end
end
