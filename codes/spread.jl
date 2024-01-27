using Plots, LinearAlgebra, QuantumInformation, LaTeXStrings

u, d = ket(1, 2), ket(2, 2);
r, l = 1 / sqrt(2) * (u + d), 1 / sqrt(2) * (u - d);

Id, X, Y, Z, H = Matrix{Int}(I, 2, 2), [0 1; 1 0], [0 -im; im 0], [1 0; 0 -1], 1 / sqrt(2) * [1 1; 1 -1];

CH = [1 0 0 0; 0 1 0 0; 0 0 1/sqrt(2) 1/sqrt(2); 0 0 1/sqrt(2) -1/sqrt(2)]

Sz = [1 0; 0 -1] # Pauli Matrix Z

ψ = kron(r, l, l, u, r, l, r, l); # Initial state

function state_evolution(state::Vector{ComplexF64}, no_of_generations::Int64)
    odd_gen_mat = kron(CH, CH, CH, CH)
    even_gen_mat = kron(Id, CH, CH, CH, Id)
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

function expectation_value(state::Vector{ComplexF64}, operator::Matrix{Int64})
    return abs(state' * operator * state) < 1e-10 ? 0 : abs(state' * operator * state)
end

Sz1 = kron(Sz, Id, Id, Id, Id, Id, Id, Id)
Sz2 = kron(Id, Sz, Id, Id, Id, Id, Id, Id)
Sz3 = kron(Id, Id, Sz, Id, Id, Id, Id, Id)
Sz4 = kron(Id, Id, Id, Sz, Id, Id, Id, Id)
Sz5 = kron(Id, Id, Id, Id, Sz, Id, Id, Id)
Sz6 = kron(Id, Id, Id, Id, Id, Sz, Id, Id)
Sz7 = kron(Id, Id, Id, Id, Id, Id, Sz, Id)
Sz8 = kron(Id, Id, Id, Id, Id, Id, Id, Sz)

operator_list = [Sz1, Sz2, Sz3, Sz4, Sz5, Sz6, Sz7, Sz8]

function expectation_value_chain(state::Vector{ComplexF64}, list_of_operators::Vector{Matrix{Int64}})
    no_of_qubits = Int(log2(length(state)))
    expectation_cells = zeros(Float64, no_of_qubits)
    for i in 1:no_of_qubits
        expectation_cells[i] = abs(expectation_value(state, list_of_operators[i]))
    end
    return expectation_cells
end

function generate_matrix(state::Vector{ComplexF64}, generation::Int64, list_of_operators::Vector{Matrix{Int64}})
    no_of_qubits = Int(log2(length(state)))
    matrix_expect = zeros(Float64, generation + 1, no_of_qubits)
    matrix_expect[1, :] = expectation_value_chain(state, list_of_operators)
    for i in 2:generation+1
        gen_state = state_evolution(state, i)
        matrix_expect[i, :] = expectation_value_chain(gen_state, list_of_operators)
    end
    return matrix_expect
end

operator_spread = generate_matrix(ψ, 100, operator_list)

h = heatmap(operator_spread, size=(600, 500), dpi=300,
    # guidefontsize=15, tickfontsize=10, 
    xticks=0:1:8, xlabel="Qubits", ylabel=L"Time $(\tau) \longrightarrow$", cbar_title=L"Expectation Value of $S_Z$",
    c=:inferno, background_color=:transparent, fontfamily="Computer Modern")
savefig(h, "spread-Sz.png")
display(h)
