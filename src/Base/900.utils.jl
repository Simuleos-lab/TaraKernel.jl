## .- .- -. -. -.- .- - .- -.- ..- .--. -. -.-.--.-. 
# MARK: random record

# Optional: just for documentation

const _HARD_ABC = Char(32):Char(127)
const JSONPOINTER_KEY_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-/~"


"""
    random_lite_scalar(rng) -> LiteScalar

Generate a random lite scalar value.
"""
function random_lite_scalar(
        rng::AbstractRNG;
        scalar_abc = _HARD_ABC
    )
    kind = rand(rng, 1:5)
    if kind == 1
        return rand(rng, -10:10)              # Int
    elseif kind == 2
        return rand(rng)                      # Float64 in [0,1)
    elseif kind == 3
        return rand(rng, Bool)                # Bool
    elseif kind == 4
        # random ASCII-ish string
        len = rand(2:50)
        return join(rand(rng, scalar_abc, len))  # String
    else
        return nothing                        # JSON null-equivalent
    end
end


function random_lite_value(
    rng::AbstractRNG, 
    depth::Int; 
    max_keys::Int=4, 
    max_len::Int=4
)
    if depth <= 0
        return random_lite_scalar(rng)
    end

    # 1 = scalar, 2 = dict, 3 = array
    choice = rand(rng, 1:3)

    if choice == 1
        return random_lite_scalar(rng)

    elseif choice == 2
        # nested dict
        return random_lite_dict(rng, depth; max_keys, max_len)

    else
        # array of lite values
        n = rand(rng, 0:max_len)
        vals = Vector{Any}(undef, n)
        for i in 1:n
            vals[i] = random_lite_scalar(rng)
        end
        return vals
    end
end

function random_lite_dict(
    rng::AbstractRNG, 
    depth::Int; 
    max_keys::Int=4, 
    max_len::Int=4, 
    keys_abc = JSONPOINTER_KEY_CHARS
)
    d = Dict{String, Any}()
    n_keys = rand(rng, 0:max_keys)

    for i in 1:n_keys
        len = rand(1:3)
        key = join(rand(rng, keys_abc, len))
        d[key] = random_lite_value(rng, depth - 1; max_keys=max_keys, max_len=max_len)
    end

    return d
end

# Convenience wrapper using the global RNG
random_lite_dict(
    depth::Int; 
    max_keys::Int=4, 
    max_len::Int=4
) =
    random_lite_dict(Random.default_rng(), depth; max_keys=max_keys, max_len=max_len)
