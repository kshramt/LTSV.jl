import Base.Test: @test, @test_throws

# Just in a case where `LTSV` is not in `~/.julia`
unshift!(LOAD_PATH, joinpath(dirname(@__FILE__), "..", "src"))
import LTSV

let
    io = IOBuffer("a:b	month:11	c:1

a:e

")
    @test LTSV.load(io, ["month"=>int]) == [["a"=>"b", "c"=>"1", "month"=>11],
                                            ["a"=>"e"]]
end

let
    io = IOBuffer(true, true)
    LTSV.dump(io,
              [["a"=>"b", "c"=>"1", "month"=>11],
               ["a"=>"e"]],
              ["month"=>x->2x])
    @test readall(seekstart(io)) in ["a:b\tc:1\tmonth:22\na:e\n",
                                     "a:b\tmonth:22\tc:1\na:e\n",
                                     "c:1\ta:b\tmonth:22\na:e\n",
                                     "c:1\tmonth:22\ta:b\na:e\n",
                                     "month:22\ta:b\tc:1\na:e\n",
                                     "month:22\tc:1\ta:b\na:e\n"]
end
