module LTSV

export load, parse, parse_line

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

end
