defmodule AutomataTest do
  use ExUnit.Case

  test "determinize funciona" do
    nfa = Automata.nfa_example()
    dfa = Automata.determinize(nfa)

    assert dfa.start == [0]
    assert length(dfa.states) > 0
  end

  test "e_closure sin epsilon regresa lo mismo" do
    nfa = Automata.nfa_example()

    result = Automata.e_closure(nfa, [0])

    assert result == [0]
  end

  test "e_determinize funciona" do
  nfa = Automata.nfa_example()

  dfa = Automata.e_determinize(nfa)

  assert length(dfa.states) > 0
end
end
