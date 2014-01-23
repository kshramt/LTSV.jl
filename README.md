# LTSV

Labeled Tab Separated Values (LTSV) parser in Julia.

## Examples

```julia
import LTSV

while true
    line = readline(STDIN)
    if isempty(line)
        break
    end
    record = LTSV.parse_line(line)
    if haskey(record, "time")
        try
            println(record["time"])
        catch
            break
        end
    end
end
```
