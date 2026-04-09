defmodule Automata do

  # Automata no determinista
  def nfa_example do
    %{
      states: [0, 1, 2, 3],
      alphabet: [:a, :b],
      transitions: %{
        {0, :a} => [0, 1],
        {0, :b} => [0],
        {1, :b} => [2],
        {2, :b} => [3]
      },
      start: 0,
      final: [3]
    }
  end

  # Convierte NFA a DFA
  def determinize(nfa) do
    start = [nfa.start]

    {states, transitions} = build_dfa([start], [], %{}, nfa)

    final_states =
      Enum.filter(states, fn state ->
        Enum.any?(state, fn s -> s in nfa.final end)
      end)

    %{
      states: states,
      alphabet: nfa.alphabet,
      transitions: transitions,
      start: start,
      final: final_states
    }
  end

  # Construcción del DFA
  defp build_dfa([], visited, transitions, _nfa) do
    {visited, transitions}
  end

  defp build_dfa([current | rest], visited, transitions, nfa) do
    if current in visited do
      build_dfa(rest, visited, transitions, nfa)
    else
      {new_queue, new_transitions} =
        Enum.reduce(nfa.alphabet, {rest, transitions}, fn symbol, {queue, trans} ->

          next =
            Enum.flat_map(current, fn s ->
              Map.get(nfa.transitions, {s, symbol}, [])
            end)
            |> Enum.uniq()

          trans = Map.put(trans, {current, symbol}, next)

          if next == [] or next in visited or next in queue do
            {queue, trans}
          else
            {queue ++ [next], trans}
          end
        end)

      build_dfa(new_queue, visited ++ [current], new_transitions, nfa)
    end
  end

end
