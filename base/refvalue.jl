# This file is a part of Julia. License is MIT: https://julialang.org/license

### Methods for a Ref object that can store a single value of any type

mutable struct RefValue{T} <: Ref{T}
    x::T
    RefValue{T}() where {T} = new()
    RefValue{T}(x) where {T} = new(x)
end
RefValue(x::T) where {T} = RefValue{T}(x)
isassigned(x::RefValue) = isdefined(x, :x)

function unsafe_convert(P::Union{Type{Ptr{T}},Type{Ptr{Cvoid}}}, b::RefValue{T})::P where T
    if allocatedinline(T)
        p = pointer_from_objref(b)
    elseif isconcretetype(T) && T.mutable
        p = pointer_from_objref(b.x)
    else
        # If the slot is not leaf type, it could be either immutable or not.
        # If it is actually an immutable, then we can't take it's pointer directly
        # Instead, explicitly load the pointer from the `RefValue`,
        # which also ensures this returns same pointer as the one rooted in the `RefValue` object.
        p = pointerref(Ptr{Ptr{Cvoid}}(pointer_from_objref(b)), 1, Core.sizeof(Ptr{Cvoid}))
    end
    return p
end
function unsafe_convert(::Type{Ptr{Any}}, b::RefValue{Any})::Ptr{Any}
    return pointer_from_objref(b)
end

getindex(b::RefValue) = b.x
setindex!(b::RefValue, x) = (b.x = x; b)
