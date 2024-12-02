xquery version "3.1";
declare default function namespace "http://www.w3.org/2005/xquery-local-functions";

declare function part1($rows as xs:string*) {
  let $left := column($rows, 1)
  let $right := column($rows, 2)
  return fn:sum(
    for $l at $idx in $left 
    let $r := $right[$idx]
    return fn:abs($l - $r)
  )
};

declare function column($rows, $idx) {
  for $row in $rows
  let $el := fn:tokenize($row)[$idx] ! xs:int(.)
  order by $el
  return $el
};

declare function part2($rows) {
  let $left := column($rows, 1)
  let $right := column($rows, 2)
  return fn:sum(
    for $l in $left
    return $l * fn:count($right[. = $l])
  )
};


let $example := file:read-text-lines("inputs/day01_ex.txt")
let $input := file:read-text-lines("inputs/day01.txt")
return (
  part1($example) = 11,
  part1($input),
  part2($example) = 31,
  part2($input)
)
