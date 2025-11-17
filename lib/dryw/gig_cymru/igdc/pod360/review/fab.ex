defmodule Dryw.GigCymru.Igdc.Pod360.Review.Fab do
  defmacro __using__(_opts) do
    quote do
      import Dryw.Fab

      def fab!(map \\ %{}) do
        __MODULE__ |> Ash.Changeset.for_create(:create, __MODULE__.fab_map(map)) |> Ash.create!()
      end

      def fab_map(map \\ %{}) do
        Map.merge(
          %{
            collaboration: 20,
            innovation: 40,
            inclusive: 60,
            excellence: 80,
            compassion: 100,
          },
          map
        )
      end

    end
  end
end
