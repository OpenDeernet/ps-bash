using PsBash.Differential.Tests.Oracle;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary><c>"${a[@]}"</c> and <c>"$@"</c> beside other words were joined into ONE argument.</summary>
public class QuotedArrayArgsTests
{
    [Fact] public Task Array_BesideOtherArg() => AssertOracle.EqualAsync("c=(a b c); printf '[%s]' \"${c[@]}\" z; echo");
    [Fact] public Task Positional_BesideOtherArg() => AssertOracle.EqualAsync("set -- 'x y' z; printf '[%s]' \"$@\" end; echo");
    [Fact] public Task EmptyArray_ContributesNothing() => AssertOracle.EqualAsync("e=(); printf '[%s]' \"${e[@]}\" end; echo");
    [Fact] public Task Array_Alone() => AssertOracle.EqualAsync("c=(a b c); printf '[%s]' \"${c[@]}\"; echo");
    [Fact] public Task ForList_Flattens() => AssertOracle.EqualAsync("c=(a b c); for i in \"${c[@]}\" q; do echo -n \"<$i>\"; done; echo");
    [Fact] public Task ArrayLiteral_Flattens() => AssertOracle.EqualAsync("c=(a 'b b' c); d=(\"${c[@]}\" w); echo \"${#d[@]}\"; f=(${c[@]} m); echo \"${#f[@]}\"; g=({1..3} n); echo \"${#g[@]}\"");
    [Fact] public Task StarJoined_StaysOneWord() => AssertOracle.EqualAsync("c=(a b c); printf '[%s]' \"${c[*]}\" z; echo");
}
