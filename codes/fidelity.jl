using Plots, LinearAlgebra, QuantumInformation, LaTeXStrings, Latexify;
pgfplotsx();

u, d = ket(1, 2), ket(2, 2);
r, l = 1 / sqrt(2) * (u + d), 1 / sqrt(2) * (u - d);

Id, X, Y, Z, H = Matrix{Int}(I, 2, 2), [0 1; 1 0], [0 -im; im 0], [1 0; 0 -1], 1 / sqrt(2) * [1 1; 1 -1];

CY = [1 0 0 0; 0 1 0 0; 0 0 0 -1im; 0 0 1im 0];
CZ = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 -1];
CH = [1 0 0 0; 0 1 0 0; 0 0 1/sqrt(2) 1/sqrt(2); 0 0 1/sqrt(2) -1/sqrt(2)];
ψ = kron(r, l, r, l)

function state_evolution(state::Vector{ComplexF64}, no_of_generations)
    # odd_gen_mat = kron(CY, CY)
    # even_gen_mat = kron(Id, CY, Id)
    odd_gen_mat = kron(CZ, CZ)
    even_gen_mat = kron(Id, CZ, Id)
    # odd_gen_mat = kron(CH, CH)
    # even_gen_mat = kron(Id, CH, Id)
    counter = 0
    final_state = state
    while counter < no_of_generations
        counter += 1
        if counter % 2 == 1
            final_state = odd_gen_mat * final_state
        else
            final_state = even_gen_mat * final_state
        end
    end
    return final_state
end

function fidelity(initial_state::Vector{ComplexF64}, final_state::Vector{ComplexF64})
    return abs(initial_state' * final_state)^2
end

time = 0:1:100;

fidelity_plot = [fidelity(state_evolution(ψ, t), ψ) for t in time]

plot_height, plot_width = 11.69, 8.27
p = plot(time, fidelity_plot, label="Fidelity", lw=2)
plot!(
    size=(900, 600),
    extra_kwargs=Dict(:plot => Dict("height" => "$(plot_height)in", "width" => "$(plot_width)in")),
    dpi=300,
    xlabel=L"Number of Generations $(\tau)$",
    ylabel=L"Fidelity $(F_{\psi}(\tau))$",
    legendfontsize=20,
    titlefontsize=20,
    tickfontsize=15,
    guidefontsize=20,
    ga=0.25,
    draw_arrow=true,
    legend=:topright
)
# savefig(p, "fidelity_plot_CY.tikz")
savefig(p, "fidelity_plot_CZ.tikz")
# savefig(p, "fidelity_plot_CH.tikz")
display(p)
