## Absorbed from Differential.Tests/AssociativeArrayTests.cs (scripts only; expectations recorded from bash 5.2).

#### Literal_ReadsAndCounts
declare -A m=([k1]=v1 [k2]=v2); echo "${m[k1]} ${m[k2]} ${#m[@]}"
## stdout: v1 v2 2
## status: 0

#### Keys_Loop
declare -A m=([k1]=v1 [k2]=v2); for k in "${!m[@]}"; do echo "k=$k"; done | sort
## STDOUT:
k=k1
k=k2
## END
## status: 0

#### VariableSubscript
declare -A n; n[x]=1; n[y]=2; for k in "${!n[@]}"; do echo "$k=${n[$k]}"; done | sort
## STDOUT:
x=1
y=2
## END
## status: 0

#### Values_Expand
declare -A m=([a]=1 [b]=2 [c]=3); for v in "${m[@]}"; do echo $v; done | sort; echo "${m[@]}" | tr ' ' '\n' | sort | tr '\n' ' '; echo
## STDOUT:
1
2
3
1 2 3 
## END
## status: 0

#### Unset_Key
declare -A n; n[x]=1; n[y]=2; unset 'n[x]'; echo "${#n[@]} [${n[x]}] ${n[y]}"
## stdout: 1 [] 2
## status: 0

#### Unset_IndexedElement
b=(p q r); unset 'b[1]'; echo "${#b[@]} ${b[@]}"
## stdout: 2 p r
## status: 0

#### IndexedArray_VariableIndex
c=(a b c); for i in 0 1 2; do echo -n "${c[$i]} "; done; echo
## stdout: a b c 
## status: 0

#### Literal_WithExpansionValue
v=zz; declare -A m=([a]=$v [b]="x y"); echo "${m[a]}|${m[b]}"
## stdout: zz|x y
## status: 0
