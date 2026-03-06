TITLE: Cryptographically Verifiable Utility-Weighted Allocation Model
STATUS: Private Research Draft (Final ASCII Version)

---------------------------------------
SECTION 0 - CONSTANTS
---------------------------------------

S = 1000000   // fixed point precision

All rational values are represented as integers scaled by S.

---------------------------------------
SECTION 1 - ENGAGEMENT MODEL
---------------------------------------

For each user u and epoch E:

e_i in [0,1]

Weights:
w_i in [0,0.4]

Constraints:
sum(w_i) = 1
n >= 3

Weighted Engagement:

W(u,E) = sum( w_i * e_i )

Integer form:

W_int = floor( S * W )

0 <= W_int <= S

---------------------------------------
SECTION 2 - TIME DECAY
---------------------------------------

delta_t = current_epoch - last_active_epoch

e_int = max(0, S - (delta_t * S / T_max))

No floating math used.

---------------------------------------
SECTION 3 - SMOOTHING FUNCTION
---------------------------------------

If W_int <= S/2:

    S_int = (2 * W_int * W_int) / S

Else:

    diff = S - W_int
    S_int = S - (2 * diff * diff) / S

---------------------------------------
SECTION 4 - FINAL ALLOCATION
---------------------------------------

A_int = p_floor_int
        + ((S - p_floor_int) * S_int) / S

0 <= A_int <= S

---------------------------------------
SECTION 5 - SIGNATURE COMMITMENT
---------------------------------------

message = encode(user || epoch || W_int || A_int)

hash = SHA256(message)

Option A - HMAC:
signature = HMAC(key, hash)

Option B - Asymmetric:
signature = Sign(private_key, hash)

---------------------------------------
SECTION 6 - MERKLE AGGREGATION
---------------------------------------

leaf = SHA256(user || W_int || A_int)

Merkle root per epoch published.

User proves inclusion with Merkle proof.

---------------------------------------
SECTION 7 - ZK VARIANT (COMMITMENT MODEL)
---------------------------------------

Pedersen commitment per component:

C_i = g^e_i * h^r_i

Weighted commitment:

C_W = product( C_i ^ w_i )

Prove in zero knowledge:
- e_i in range [0,1]
- weighted sum equals W

Verifier checks proof without revealing e_i.

---------------------------------------
SECTION 8 - ON-CHAIN VERIFICATION (PSEUDOCODE)
---------------------------------------

function verify(user, epoch, W_int, A_int):

    require(W_int <= S)

    if W_int <= S/2:
        S_int = (2 * W_int * W_int) / S
    else:
        diff = S - W_int
        S_int = S - (2 * diff * diff) / S

    computedA =
        p_floor_int
        + ((S - p_floor_int) * S_int) / S

    require(computedA == A_int)

    verify_merkle_proof(...)
    verify_signature(...)

    return true

---------------------------------------
SECTION 9 - MONOTONICITY PROOF (SKETCH)
---------------------------------------

For W <= 0.5:
    derivative S'(W) = 4W > 0

For W > 0.5:
    derivative S'(W) = 4(1 - W) > 0

Therefore S(W) strictly increasing.

Since:
A(W) = p_floor + (1 - p_floor) * S(W)

And (1 - p_floor) > 0

A(W) is strictly increasing.

---------------------------------------
SECTION 10 - GAME THEORY MODEL
---------------------------------------

User payoff:

Pi(u) = Allocation(u) - Cost(e)

Assume convex cost:

Cost(e) = k * sum( e_i^2 )

Equilibrium condition:

dA/de_i = dCost/de_i

Since:
- weights bounded (<= 0.4)
- smoothing bounded
- gradient bounded

No incentive for extreme single-metric inflation.

Interior equilibrium exists.

---------------------------------------
END OF FILE
---------------------------------------
