dir=$1; out=$2; skip=$3
: > "$out"
for f in "$dir"/*.sh; do
  id=$(basename "$f" .sh)
  case " $skip " in *" $id "*) printf '%s|HANG|\n' "$id" >> "$out"; continue;; esac
  res=$( ( . "$f" ) 2>&1 </dev/null ); rc=$?
  res=$(printf '%s' "$res" | tr '\n\r' '~ ')
  printf '%s|%s|%s\n' "$id" "$rc" "$res" >> "$out"
done