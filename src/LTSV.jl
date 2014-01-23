module LTSV

load(f::String, converters::Dict=Dict()) = open(io->load(io, converters), f, "r")
load(io::IO, converters::Dict=Dict()) = parse(readall(io), converters)

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

dump(f::String, v, converters::Dict=Dict()) = open(io->dump(io, v, converters), f, "w")
dump(io::IO, v, converters::Dict=Dict()) = write(io, string(v, converters))

string(ds, converters::Dict=Dict()) = join(map(d->string(d, converters), ds))
function string(d::Dict, converters::Dict=Dict())
    Base.string(join(map(d) do kv
                         k, v = kv
                        "$k:$(get(converters, k, identity)(v))"
                     end,
                '\t'),
                '\n')
end

end
