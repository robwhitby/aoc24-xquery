xquery version "3.1";
declare default function namespace "http://www.w3.org/2005/xquery-local-functions";

declare function part1($rows as xs:string*) {
  fn:count(
    for $row in $rows
    let $ints := fn:tokenize($row) ! xs:int(.)
    where safe($ints)
    return $row
  )
};

declare function safe($row as xs:int+) {
  let $ordered := 
    let $sorted := for $el in $row order by $el return $el
    return fn:deep-equal($row, $sorted) or fn:deep-equal(fn:reverse($row), $sorted)

  let $diffs := 
    for sliding window $w in $row
      start at $i when fn:true()
      only end at $j when $j - $i = 1
    let $diff := fn:abs($w[1] - $w[2])
    return $diff >= 1 and $diff <= 3
  
  return $ordered and fn:not($diffs = fn:false())
};

declare function part2($rows) {
  fn:count(
    for $row in $rows
    let $ints := fn:tokenize($row) ! xs:int(.)
    return (
      for $n in 1 to fn:count($ints)
      let $combo := for $int at $idx in $ints where $idx != $n return $int
      where safe($combo)
      return $combo
    )[1]
  )
};


let $example := file:read-text-lines("inputs/day02_ex.txt")
let $input := file:read-text-lines("inputs/day02.txt")
return (
  part1($example) = 2,
  part1($input),
  part2($example) = 4,
  part2($input)
)
