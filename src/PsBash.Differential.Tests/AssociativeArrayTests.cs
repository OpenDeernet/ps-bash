using PsBash.Differential.Tests.Oracle;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary>Associative-array literals, key/value expansion, <c>unset arr[i]</c> and variable subscripts.</summary>
public class AssociativeArrayTests
{
    [Fact] public Task Literal_ReadsAndCounts() => AssertOracle.EqualAsync("declare -A m=([k1]=v1 [k2]=v2); echo \"${m[k1]} ${m[k2]} ${#m[@]}\"");
    [Fact] public Task Keys_Loop() => AssertOracle.EqualAsync("declare -A m=([k1]=v1 [k2]=v2); for k in \"${!m[@]}\"; do echo \"k=$k\"; done | sort");
    [Fact] public Task VariableSubscript() => AssertOracle.EqualAsync("declare -A n; n[x]=1; n[y]=2; for k in \"${!n[@]}\"; do echo \"$k=${n[$k]}\"; done | sort");
    [Fact] public Task Values_Expand() => AssertOracle.EqualAsync("declare -A m=([a]=1 [b]=2 [c]=3); for v in \"${m[@]}\"; do echo $v; done | sort; echo \"${m[@]}\" | tr ' ' '\\n' | sort | tr '\\n' ' '; echo");
    [Fact] public Task Unset_Key() => AssertOracle.EqualAsync("declare -A n; n[x]=1; n[y]=2; unset 'n[x]'; echo \"${#n[@]} [${n[x]}] ${n[y]}\"");
    [Fact] public Task Unset_IndexedElement() => AssertOracle.EqualAsync("b=(p q r); unset 'b[1]'; echo \"${#b[@]} ${b[@]}\"");
    [Fact] public Task IndexedArray_VariableIndex() => AssertOracle.EqualAsync("c=(a b c); for i in 0 1 2; do echo -n \"${c[$i]} \"; done; echo");
    [Fact] public Task Literal_WithExpansionValue() => AssertOracle.EqualAsync("v=zz; declare -A m=([a]=$v [b]=\"x y\"); echo \"${m[a]}|${m[b]}\"");
}
