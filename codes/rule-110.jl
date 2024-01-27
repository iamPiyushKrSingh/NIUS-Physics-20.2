using Plots;

rule = Dict([0, 0, 0] => 0, [0, 0, 1] => 1, [0, 1, 0] => 1, [0, 1, 1] => 1, [1, 0, 0] => 0, [1, 0, 1] => 1, [1, 1, 0] => 1, [1, 1, 1] => 0)

function next_generation(state)
    new_state = zeros(Int, length(state))
    for i in 2:length(state)-1
        neighbour = state[i-1:i+1]
        new_state[i] = rule[neighbour]
    end
    return new_state
end

function generate_automaton(generations, initial_state)
    automaton = zeros(Int, generations, length(initial_state))
    automaton[1, :] = initial_state
    for i in 2:generations
        automaton[i, :] = next_generation(automaton[i-1, :])
    end
    return automaton
end

initial_state = zeros(Int, 101)
initial_state[100] = 1

# Generate the Rule 110 cellular automaton with 100 time steps
generations = 100
automaton = generate_automaton(generations, initial_state);

# Plot the cellular automaton
p = heatmap(automaton, c=:cividis, xlabel="Cell Index", ylabel="Time Steps", cbar=false)
plot!(
    # size=(0, 550),
    # guidefontsize=20,
    # tickfontsize=15,
    dpi=300,
    background_color=:transparent,
    fontfamily="Computer Modern"
)
savefig(p, "rule110_cellular_automaton.png")
display(p)