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

  # epsilon closure (AHORA SÍ dentro del módulo)
  def e_closure(nfa, states) do
    closure(states, states, nfa)
  end

  defp closure([], visited, _nfa), do: visited

  defp closure([current | rest], visited, nfa) do
    next = Map.get(nfa.transitions, {current, :e}, [])

    new_states =
      Enum.filter(next, fn s -> not (s in visited) end)

    closure(rest ++ new_states, visited ++ new_states, nfa)
  end

  #funcion e_determinize/1
  def e_determinize(nfa) do
  start = e_closure(nfa, [nfa.start])

  {states, transitions} = build_e_dfa([start], [], %{}, nfa)

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

defp build_e_dfa([], visited, transitions, _nfa) do
  {visited, transitions}
end

defp build_e_dfa([current | rest], visited, transitions, nfa) do
  if current in visited do
    build_e_dfa(rest, visited, transitions, nfa)
  else
    {new_queue, new_transitions} =
      Enum.reduce(nfa.alphabet, {rest, transitions}, fn symbol, {queue, trans} ->

        move =
          Enum.flat_map(current, fn s ->
            Map.get(nfa.transitions, {s, symbol}, [])
          end)

        next =
          move
          |> Enum.flat_map(fn s -> e_closure(nfa, [s]) end)
          |> Enum.uniq()

        trans = Map.put(trans, {current, symbol}, next)

        if next == [] or next in visited or next in queue do
          {queue, trans}
        else
          {queue ++ [next], trans}
        end
      end)

    build_e_dfa(new_queue, visited ++ [current], new_transitions, nfa)
  end
end

end
