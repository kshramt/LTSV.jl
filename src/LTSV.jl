module LTSV

export load, parse, parse_line, dump, string

function load(f::String, converters::Dict=Dict())
    open(f, "r") do io
        load(io, converters)
    end
end

function load(io::IO, converters::Dict=Dict())
    parse(readall(io), converters)
end

function parse(lines::String, converters::Dict=Dict())
    ret = Dict{String, Any}[]
    for line in split(lines, '\n')
        if !isempty(line)
            push!(ret, parse_line(line, converters))
        end
    end
    ret
end

function parse_line(line::String, converters::Dict=Dict())
    ret = Dict{String, Any}()
    for field in split(chomp(line), '\t')
        key, value = split(field, ':', 2)
        ret[key] = get(converters, key, identity)(value)
    end
    ret
end

function dump(f::String, v, converters::Dict=Dict())
    open(f, "w") do io
        dump(io, v, converters)
    end
end

function dump(io::IO, v, converters::Dict=Dict())
    write(io, string(v, converters))
end

function string(ds, converters::Dict=Dict())
    join(map(ds) do d
             string(d, converters)
         end)
end

function string(d::Dict, converters::Dict=Dict())
    Base.string(join(map(d) do kv
                         k, v = kv
                        "$k:$(get(converters, k, identity)(v))"
                     end,
                '\t'),
                '\n')
end

end
