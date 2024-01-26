using LinearAlgebra, QuantumInformation, Latexify

u, d = ket(1, 2), ket(2, 2);
r, l = 1 / sqrt(2) * (u + d), 1 / sqrt(2) * (u - d);

Id, X, Y, Z, H = Matrix{Int}(I, 2, 2), [0 1; 1 0], [0 -im; im 0], [1 0; 0 -1], 1 / sqrt(2) * [1 1; 1 -1];

CH = [1 0 0 0; 0 1 0 0; 0 0 1/sqrt(2) 1/sqrt(2); 0 0 1/sqrt(2) -1/sqrt(2)]

ψ = kron(r, l, r, l)

function state_evolution(state::Vector{ComplexF64}, no_of_generations)
    odd_gen_mat = kron(CH, CH)
    even_gen_mat = kron(Id, CH, Id)
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

ψ_F = state_evolution(ψ, 4)
print(latexify(ψ_F))