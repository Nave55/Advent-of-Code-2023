package AoC

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:slice"
import "core:math"

main :: proc() {
    content := parsefile("./AoC Files/Day4.txt")
    p1 := solution1(content)
    p2 := solution2(content)
    fmt.printf("Part 1: %v\nPart 2: %v", p1, p2)
}

parsefile :: proc(filepath: string) -> (a: [dynamic][dynamic][]string){
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok do return 
    defer delete(data, context.allocator)  

    it, _ := strings.replace(string(data), "  ", " ", -1)
    it, _ = strings.replace(it, " | ", "|", -1)

    for line in strings.split_lines_iterator(&it) {
        tmp : [dynamic][]string
        for i in strings.split(line[strings.index_any(line,":")+2:], "|") {
            append_elems(&tmp,strings.split(i, " "))
        }
        append_elems(&a, tmp)
    }
    return a
}

solution1 :: proc(content : [dynamic][dynamic][]string) -> (ttl := 0) {
    for i in content {
        tmp := 0
        for j in i[0] {
            if slice.contains(i[1], j) {
                if tmp == 0 do tmp += 1
                else do tmp *= 2
            }
        }
        ttl += tmp
    }
    return ttl
}

solution2 :: proc(content : [dynamic][dynamic][]string) -> (ttl := 0) {
    mp := make(map[int]int)
    for i in 0..<len(content) do mp[i] = 1
    for val, ind in content {
        tmp := 0
        for i in val[0] {
            if slice.contains(val[1], i) do tmp += 1
        }
        for i in ind+1..=ind+tmp do mp[i] += mp[ind]
    }
    for key, val in mp do ttl += val
    return ttl
}