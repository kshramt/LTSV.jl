import Base.Test: @test, @test_throws

# Just in a case where `LTSV` is not in `~/.julia`
unshift!(LOAD_PATH, joinpath(dirname(@__FILE__), "..", "src"))
import LTSV

let
    io = IOString("a:b	month:11	c:1

a:e

")
    @test LTSV.load(io, ["month"=>int]) == [["a"=>"b", "c"=>"1", "month"=>11],
                                            ["a"=>"e"]]
end
