defmodule AutomataTest do
  use ExUnit.Case

  test "determinize funciona" do
    nfa = Automata.nfa_example()
    dfa = Automata.determinize(nfa)

    assert dfa.start == [0]
    assert length(dfa.states) > 0
  end
end
