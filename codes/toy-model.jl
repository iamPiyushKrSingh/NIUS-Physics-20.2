using LinearAlgebra, QuantumInformation, Latexify

# Impotant Const
u, d = ket(1, 2), ket(2, 2);
r, l = 1 / sqrt(2) * (u + d), 1 / sqrt(2) * (u - d);

Id, X, Y, Z, H = Matrix{Int}(I, 2, 2), [0 1; 1 0], [0 -im; im 0], [1 0; 0 -1], 1 / sqrt(2) * [1 1; 1 -1];

CH = [
    1 0 0 0;
    0 1 0 0;
    0 0 1/sqrt(2) 1/sqrt(2);
    0 0 1/sqrt(2) -1/sqrt(2)
]
Pd = [0 0; 0 1]

# Initial State of the system as |+-+-⟩
ψ = kron(r, l, r, l)

## Generation 1 ##

# Unitary Operators #
U1 = kron(CH, CH);
ϕ1e = U1 * ψ

# Projective Measurement #
Pd3 = kron(Id, Id, Pd, Id);
p1 = real(ϕ1e' * Pd3 * ϕ1e)
ϕ1m = ϕ1m = Pd3 * ϕ1e / sqrt(p1)
print(latexify(ϕ1m))